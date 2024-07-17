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
    
    private let provider: MoyaProvider<LoginTargetType>
    private var authService: AuthServiceType
    private let authInterceptor: AuthInterceptor
    
    
    init(
        provider: MoyaProvider<LoginTargetType> = MoyaProvider<LoginTargetType>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        ),
        authService: AuthServiceType = AuthService()
    ) {
        self.provider = provider
        self.authService = authService
        self.authInterceptor = AuthInterceptor(authService: authService, provider: provider)
        super.init()
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
    
    private func loginToServer(with loginTarget: LoginTargetType) {
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
               saveTokens(accessToken: data.jwtTokenDTO.accessToken, refreshToken: data.jwtTokenDTO.refreshToken)
               if data.name != nil {
                   print("Login successful")
                   loginState.value = .login
               } else {
                   print("Login successful, but needs onboarding.")
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
            completion(false)
            return
        }
        
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let reissueResponse = try response.map(ResponseBodyDTO<ReissueModel>.self)
                    if reissueResponse.success, let data = reissueResponse.data,
                       let newAccessToken = data.accessToken,
                       let newRefreshToken = data.refreshToken {
                        self?.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken)
                        completion(true)
                    } else {
                        print("Token refresh failed: \(reissueResponse.error?.message ?? "Unknown error")")
                        self?.authService.clearTokens()
                        completion(false)
                    }
                } catch {
                    print("Token refresh failed: \(error)")
                    self?.authService.clearTokens()
                    completion(false)
                }
            case .failure(let error):
                print("Token refresh failed: \(error)")
                self?.authService.clearTokens()
                completion(false)
            }
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        print("Attempting to save tokens")
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

extension LoginViewModel: ASAuthorizationControllerDelegate,
                          ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
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
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print(
            "Apple authorization error: \(error.localizedDescription)"
        )
        self.error.value = error.localizedDescription
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("Providing presentation anchor for Apple Login")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
    }
}
