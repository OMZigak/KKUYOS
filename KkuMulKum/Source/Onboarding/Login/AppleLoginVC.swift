//
//  LoginViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import AuthenticationServices


class AppleLoginViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .yellow
        setupAppleLoginButton()
    }
    
    func setupAppleLoginButton() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(clickAppleLogin), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        view.addSubview(button)
    }
    
    @objc func clickAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}


// MARK: - ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding

extension AppleLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let idToken = credential.identityToken!
            let tokenStr = String(data: idToken, encoding: .utf8)
            print(tokenStr ?? "No token string")
            
            guard let code = credential.authorizationCode else { return }
            let codeStr = String(data: code, encoding: .utf8)
            print(codeStr ?? "No code string")
            
            let user = credential.user
            print(user)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed with error: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
