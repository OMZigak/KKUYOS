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

enum LoginState {
    case notLogin
    case login
    case needOnboarding
}

class LoginViewModel: NSObject {
    var loginState: ObservablePattern<LoginState> = ObservablePattern(.notLogin)
    var error: ObservablePattern<String> = ObservablePattern("")
    
    private let provider: MoyaProvider<LoginTargetType>
    private var keychainService: KeychainService
    
    init(
        provider: MoyaProvider<LoginTargetType> = MoyaProvider<LoginTargetType>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        ),
        keychainService: KeychainService = DefaultKeychainService.shared
    ) {
        self.provider = provider
        self.keychainService = keychainService
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
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("Kakao Login Error: \(error.localizedDescription)")
            self.error.value = error.localizedDescription
            return
        }
        
        if let token = oauthToken?.accessToken {
            print("Kakao Login Successful, access token: \(token)")
            loginToServer(with: .kakaoLogin(accessToken: token, fcmToken: "dummy_fcm_token"))
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
                do {
                    let loginResponse = try response.map(ResponseBodyDTO<SocialLoginResponseModel>.self)
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
            if response.success {
                if let data = response.data {
                    if data.name != nil {
                        print("Login successful")
                        loginState.value = .login
                    } else {
                        print("Login successful, but needs onboarding.")
                        loginState.value = .needOnboarding
                    }
                    
                    saveTokens(accessToken: data.jwtTokenDTO.accessToken, refreshToken: data.jwtTokenDTO.refreshToken)
                } else {
                    print("Warning: No data received in response")
                    error.value = "No data received"
                }
            } else {
                if let error = response.error {
                    print("Login failed: \(error.message)")
                    self.error.value = error.message
                } else {
                    print("Login failed: Unknown error")
                    self.error.value = "Unknown error occurred"
                }
            }
        }
        
    private func saveTokens(accessToken: String, refreshToken: String) {
        keychainService.accessToken = accessToken
        keychainService.refreshToken = refreshToken
        print("Tokens saved to keychain")
        
        // 저장 후 바로 읽어서 확인
        if let savedAccessToken = keychainService.accessToken {
            print("Saved Access Token: \(savedAccessToken)")
        } else {
            print("Failed to save Access Token")
        }
        
        if let savedRefreshToken = keychainService.refreshToken {
            print("Saved Refresh Token: \(savedRefreshToken)")
        } else {
            print("Failed to save Refresh Token")
        }
    }
        
        func refreshToken() {
            guard let refreshToken = keychainService.refreshToken else {
                error.value = "No refresh token available"
                return
            }
            
            provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let refreshResponse = try response.map(ResponseBodyDTO<RefreshTokenResponseModel>.self)
                        if refreshResponse.success, let data = refreshResponse.data {
                            self?.saveTokens(accessToken: data.accessToken, refreshToken: data.refreshToken)
                            self?.loginState.value = .login
                        } else if let error = refreshResponse.error {
                            self?.error.value = error.message
                        }
                    } catch {
                        self?.error.value = "Failed to decode refresh token response"
                    }
                case .failure(let error):
                    self?.error.value = "Token refresh failed: \(error.localizedDescription)"
                }
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
        loginToServer(with: .appleLogin(identityToken: tokenString, fcmToken: "dummy_fcm_token"))
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
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
