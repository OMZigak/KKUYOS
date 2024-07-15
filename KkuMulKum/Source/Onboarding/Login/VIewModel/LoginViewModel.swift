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
    case notLoggedIn
    case loggedIn(userInfo: String)
    case needOnboarding
}

class LoginViewModel: NSObject {
    var loginState: ObservablePattern<LoginState> = ObservablePattern(.notLoggedIn)
    var error: ObservablePattern<String> = ObservablePattern("")

    private let provider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

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
        print("Performing Kakao Login")
        if UserApi.isKakaoTalkLoginAvailable() {
            print("Kakao Talk is available, using Kakao Talk login")
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            print("Kakao Talk is not available, using Kakao Account login")
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
    
    private func loginToServer(with loginService: LoginService) {
        print("Attempting to login to server")
        provider.request(loginService) { [weak self] result in
            switch result {
            case .success(let response):
                print("Received response from server: \(response)")
                do {
                    let loginResponse = try response.map(SocialLoginResponseModel.self)
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
    
    private func handleLoginResponse(_ response: SocialLoginResponseModel) {
        print("Handling login response")
        if let name = response.name {
            print("Login successful, user name: \(name)")
            loginState.value = .loggedIn(userInfo: name)
        } else {
            print("Login successful, but no name provided. Needs onboarding.")
            loginState.value = .needOnboarding
        }
        
        // TODO: 토큰 저장
        if let accessToken = response.accessToken, let refreshToken = response.refreshToken {
            print("Received tokens - Access: \(accessToken), Refresh: \(refreshToken)")
            // Save tokens to secure storage
        } else {
            print("Warning: No tokens received in response")
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
