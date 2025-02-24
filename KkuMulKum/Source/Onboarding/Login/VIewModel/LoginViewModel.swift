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
import KakaoSDKCommon
import Moya
import FirebaseMessaging

enum LoginState {
    case notLogin
    case login
    case needOnboarding
}

enum LoginNavigation {
    case toMain
    case toOnboarding
    case showError(message: String)
}

class LoginViewModel: NSObject {
    // MARK: - Outputs
    // 현재 상태
    private(set) var loginState: LoginState = .notLogin {
        didSet {
            loginStateChanged?(loginState)
        }
    }
    
    // 상태 변경 콜백
    var loginStateChanged: ((LoginState) -> Void)?
    
    // Pulse 이벤트들
    private(set) var loginResultPulse = Pulse<Result<SocialLoginResponseModel, Error>>()
    private(set) var navigationPulse = Pulse<LoginNavigation>()
    private(set) var errorPulse = Pulse<String>()
    
    // MARK: - Private properties
    private let provider: MoyaProvider<AuthTargetType>
    private var authService: AuthServiceProtocol
    private let authInterceptor: AuthInterceptor
    private let keychainAccessible: KeychainAccessible
    
    private let kakaoAppKey: String

    // MARK: - Initialization
    init(
        provider: MoyaProvider<AuthTargetType> = MoyaProvider<AuthTargetType>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        ),
        authService: AuthServiceProtocol = AuthService(),
        keychainAccessible: KeychainAccessible = DefaultKeychainAccessible()
    ) {
        if let appKey = Bundle.main.privacyInfo?["NATIVE_APP_KEY"] as? String {
            self.kakaoAppKey = appKey
        } else {
            fatalError("Failed to load NATIVE_APP_KEY from PrivacyInfo.plist")
        }
        
        self.provider = provider
        self.authService = authService
        self.authInterceptor = AuthInterceptor(authService: authService, provider: provider)
        self.keychainAccessible = keychainAccessible
        super.init()
        
        setupBindings()
        print("Initial FCM Token: \(getFCMToken())")
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // errorPulse 발생 시 navigationPulse(showError)도 함께 발생시키기
        errorPulse.subscribe { [weak self] errorMessage in
            if !errorMessage.isEmpty {
                self?.navigationPulse.emit(.showError(message: errorMessage))
            }
        }
    }
    
    // MARK: - Public Methods
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
    
    // MARK: - Private Methods
    private func getFCMToken() -> String {
        let token = keychainAccessible.getToken("FCMToken") ?? "fcm_token_not_available"
        print("Retrieved FCM Token: \(token)")
        return token
    }
    
    private func getFCMTokenAsync(completion: @escaping (String) -> Void) {
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
            errorPulse.emit(error.localizedDescription)
            return
        }
        
        if let token = oauthToken?.accessToken {
            print("Kakao Login Successful, access token: \(token)")
            getFCMTokenAsync { [weak self] fcmToken in
                self?.loginToServer(with: .kakaoLogin(accessToken: token, fcmToken: fcmToken))
            }
        } else {
            print("Kakao Login Error: No access token")
            errorPulse.emit("No access token received")
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
                    self?.errorPulse.emit("Failed to decode response: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Network error: \(error)")
                self?.errorPulse.emit("Network error: \(error.localizedDescription)")
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
            
            loginResultPulse.emit(.success(data))
            
            if data.name != nil {
                print("Login successful, user has a name")
                loginState = .login
                navigationPulse.emit(.toMain)
            } else {
                print("Login successful, but user needs onboarding")
                loginState = .needOnboarding
                navigationPulse.emit(.toOnboarding)
            }
        } else {
            if let error = response.error {
                print("Login failed: \(error.message)")
                errorPulse.emit(error.message)
            } else {
                print("Login failed: Unknown error")
                errorPulse.emit("Unknown error occurred")
            }
            loginState = .notLogin
        }
    }
    
    func autoLogin(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = authService.getRefreshToken() else {
            print("No refresh token found")
            loginState = .notLogin
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
                        if data.name != nil {
                            self?.loginState = .login
                            self?.navigationPulse.emit(.toMain)
                        } else {
                            self?.loginState = .needOnboarding
                            self?.navigationPulse.emit(.toOnboarding)
                        }
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
        loginState = .notLogin
        errorPulse.emit("자동 로그인 실패. 다시 로그인해주세요.")
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
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Apple authorization completed")
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            print("Failed to get Apple ID Credential or identity token")
            return
        }
        
        // authorization_code 출력 추가
        if let authorizationCode = appleIDCredential.authorizationCode,
           let codeString = String(data: authorizationCode, encoding: .utf8) {
            print("Authorization Code: \(codeString)")
        } else {
            print("Authorization Code not available")
        }
        
        print("Apple Login Successful, identity token: \(tokenString)")
        getFCMTokenAsync { [weak self] fcmToken in
            self?.loginToServer(with: .appleLogin(identityToken: tokenString, fcmToken: fcmToken))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple authorization error: \(error.localizedDescription)")
        errorPulse.emit(error.localizedDescription)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("Providing presentation anchor for Apple Login")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
    }
}
