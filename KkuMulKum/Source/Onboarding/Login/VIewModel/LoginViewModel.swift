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


enum LoginState {
    case notLoggedIn
    case loggedIn(userInfo: String)
}

class LoginViewModel: NSObject {
    var loginState: ObservablePattern<LoginState> = ObservablePattern(.notLoggedIn)
    var error: ObservablePattern<String> = ObservablePattern("")

    func performAppleLogin(presentationAnchor: ASPresentationAnchor) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func performKakaoLogin(presentationAnchor: UIWindow) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            self.error.value = error.localizedDescription
            return
        }
        
        if let _ = oauthToken {
            fetchKakaoUserInfo()
        }
    }
    
    private func fetchKakaoUserInfo() {
        UserApi.shared.me() { [weak self] (user, error) in
            if let error = error {
                self?.error.value = error.localizedDescription
                return
            }
            
            if let nickname = user?.kakaoAccount?.profile?.nickname {
                self?.loginState.value = .loggedIn(userInfo: "Kakao user: \(nickname)")
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Authorization failed: Credential is not of type ASAuthorizationAppleIDCredential")
            return
        }
        
        let userName = appleIDCredential.fullName?.givenName ?? "Apple user"
        loginState.value = .loggedIn(userInfo: "Apple user: \(userName)")
        
        // 액세스 토큰 출력
        if let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8) {
            print("Apple Login Access Token: \(tokenString)")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.error.value = error.localizedDescription
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window!
    }
}
