//
//  LoginVM.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth
import Moya
import FirebaseMessaging

enum LoginState {
    case notLogin
    case login
    case needOnboarding
}

class LoginViewModel: NSObject {
    var loginState: ObservablePattern<LoginState> = ObservablePattern(.notLogin)
    var error: ObservablePattern<String> = ObservablePattern("")
    var userName: ObservablePattern<String?> = ObservablePattern(nil)
    
    private let provider: MoyaProvider<AuthTargetType>
    private var authService: AuthServiceType
    private let authInterceptor: AuthInterceptor
    private let keychainAccessible: KeychainAccessible
    
    init(
        provider: MoyaProvider<AuthTargetType> = MoyaProvider<AuthTargetType>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        ),
        authService: AuthServiceType = AuthService(),
        keychainAccessible: KeychainAccessible = DefaultKeychainAccessible()
    ) {
        self.provider = provider
        self.authService = authService
        self.authInterceptor = AuthInterceptor(authService: authService, provider: provider)
        self.keychainAccessible = keychainAccessible
        super.init()
        
        print("Initial FCM Token: \(getFCMToken())")
    }
    
    private func getFCMToken() -> String {
        let token = keychainAccessible.getToken("FCMToken") ?? "fcm_token_not_available"
        print("Retrieved FCM Token: \(token)")
        return token
    }
    
    func performAppleLogin(presentationAnchor: ASPresentationAnchor) {
        print("Performing Apple Login")
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func performKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            print("Kakao Talk is available")
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            print("Kakao Talk is not available")
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    private func getFCMToken(completion: @escaping (String) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                completion("fcm_token_not_available")
            } else if let token = token {
                print("Current FCM Token: \(token)")
                UserDefaults.standard.set(token, forKey: "FCMToken")
                UserDefaults.standard.synchronize()
                completion(token)
            } else {
                completion("fcm_token_not_available")
            }
        }
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("Kakao Login Error: \(error.localizedDescription)")
            self.error.value = error.localizedDescription
            return
        }
        
        if let token = oauthToken?.accessToken {
            print("Kakao Login Successful, access token: \(token)")
            getFCMToken { [weak self] fcmToken in
                self?.loginToServer(with: .kakaoLogin(accessToken: token, fcmToken: fcmToken))
            }
        } else {
            print("Kakao Login Error: No access token")
            self.error.value = "No access token received"
        }
    }
    
    private func loginToServer(with loginTarget: AuthTargetType) {
        switch loginTarget {
        case .appleLogin(_, let fcmToken), .kakaoLogin(_, let fcmToken):
            print("Sending FCM Token to server: \(fcmToken)")
        default:
            break
        }
        
        provider.request(loginTarget) { [weak self] result in
            switch result {
            case .success(let response):
                print("Received response from server: \(response)")
                print("Response body: \(String(data: response.data, encoding: .utf8) ?? "")")
                do {
                    let loginResponse = try response.map(
                        ResponseBodyDTO<SocialLoginResponseModel>.self
                    )
                    print("Successfully mapped response: \(loginResponse)")
                    self?.handleLoginResponse(loginResponse)
                } catch {
                    print("Failed to decode response: \(error)")
                    self?.error.value = "Failed to decode response: \(error.localizedDescription)"
                }
                
            case .failure(let error):
                print("Network error: \(error)")
                self?.error.value = "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    private func handleLoginResponse(_ response: ResponseBodyDTO<SocialLoginResponseModel>) {
        print("Handling login response")
        if response.success, let data = response.data {
            saveTokens(
                accessToken: data.jwtTokenDTO.accessToken,
                refreshToken: data.jwtTokenDTO.refreshToken
            )
            userName.value = data.name
            if data.name != nil {
                print("Login successful, user has a name")
                loginState.value = .login
            } else {
                print("Login successful, but user needs onboarding")
                loginState.value = .needOnboarding
            }
        } else {
            if let error = response.error {
                print("Login failed: \(error.message)")
                self.error.value = error.message
            } else {
                print("Login failed: Unknown error")
                self.error.value = "Unknown error occurred"
            }
            loginState.value = .notLogin
        }
    }
    
    func autoLogin(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = authService.getRefreshToken() else {
            print("No refresh token found")
            loginState.value = .notLogin
            completion(false)
            return
        }
        
        print("Attempting auto login with refresh token")
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let reissueResponse = try response.map(ResponseBodyDTO<RefreshTokenResponseModel>.self)
                    if reissueResponse.success, let data = reissueResponse.data {
                        let newAccessToken = data.accessToken
                        let newRefreshToken = data.refreshToken
                        self?.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken)
                        
                        self?.fetchUserInfo { success in
                            if success {
                                completion(true)
                            } else {
                                self?.clearTokensAndHandleError()
                                completion(false)
                            }
                        }
                    } else {
                        print("Token refresh failed: \(reissueResponse.error?.message ?? "Unknown error")")
                        self?.clearTokensAndHandleError()
                        completion(false)
                    }
                } catch {
                    print("Token refresh failed: \(error)")
                    self?.clearTokensAndHandleError()
                    completion(false)
                }
            case .failure(let error):
                print("Network error during auto login: \(error)")
                self?.clearTokensAndHandleError()
                completion(false)
            }
        }
    }
    
    private func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        provider.request(.getUserInfo) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let userInfoResponse = try response.map(ResponseBodyDTO<UserInfoModel>.self)
                    if userInfoResponse.success, let data = userInfoResponse.data {
                        self?.userName.value = data.name
                        self?.loginState.value = .login  // 이름이 있으므로 항상 .login 상태로 설정
                        completion(true)
                    } else {
                        self?.clearTokensAndHandleError()
                        completion(false)
                    }
                } catch {
                    print("Failed to decode user info: \(error)")
                    self?.clearTokensAndHandleError()
                    completion(false)
                }
            case .failure(let error):
                print("Failed to fetch user info: \(error)")
                self?.clearTokensAndHandleError()
                completion(false)
            }
        }
    }
    
    private func clearTokensAndHandleError() {
        _ = authService.clearTokens()
        loginState.value = .notLogin
        error.value = "자동 로그인 실패. 다시 로그인해주세요."
        print("Tokens cleared, login state set to notLogin")
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {

        let accessTokenSaved = authService.saveAccessToken(accessToken)
        let refreshTokenSaved = authService.saveRefreshToken(refreshToken)
        
        print("Access token saved: \(accessTokenSaved), Refresh token saved: \(refreshTokenSaved)")
        
        if accessTokenSaved && refreshTokenSaved {
            print("Tokens successfully saved")
        } else {
            print("Failed to save tokens")
        }
    }
    
    // TODO: 자동로그인 구현 후 삭제예정
    func fetchValueFromPrivacyInfo(forKey key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "PrivacyInfo", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
              let value = dict[key] as? String else {
            return nil
        }
        return value
    }
    
    // TODO: 자동로그인 구현 후 삭제예정
    func performTestLogin() {
          guard let testAccessToken = fetchValueFromPrivacyInfo(forKey: "TEST_ACCESS_TOKEN") else {
              print("Failed to retrieve test access token")
              error.value = "Test access token not found"
              return
          }
          
          saveTokens(accessToken: testAccessToken, refreshToken: "")
          userName.value = ""
          loginState.value = .login
      }
    

}

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Apple authorization completed")
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            print("Failed to get Apple ID Credential or identity token")
            return
        }
        
        print("Apple Login Successful, identity token: \(tokenString)")
        getFCMToken { [weak self] fcmToken in
            self?.loginToServer(with: .appleLogin(identityToken: tokenString, fcmToken: fcmToken))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple authorization error: \(error.localizedDescription)")
        self.error.value = error.localizedDescription
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("Providing presentation anchor for Apple Login")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
    }
}
