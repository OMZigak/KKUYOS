//
//  LoginVC.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import AuthenticationServices

class LoginViewController: BaseViewController {
    
    private let loginView = LoginView()
    private let loginViewModel = LoginViewModel()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        bindViewModel()
    }
    
    override func setupAction() {
        super.setupAction()
        
        let appleTapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginTapped))
        loginView.appleLoginImageView.addGestureRecognizer(appleTapGesture)
        
        let kakaoTapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginTapped))
        loginView.kakaoLoginImageView.addGestureRecognizer(kakaoTapGesture)
    }
    
    private func bindViewModel() {
        
        loginViewModel.loginState.bind(with: self) { (self, state) in
            switch state {
            case .notLoggedIn:
                print("Not logged in")
            case .loggedIn(let userInfo):
                print("Logged in: \(userInfo)")
            }
        }
        
        loginViewModel.error.bind(with: self) { (self, error) in
            if let error = error {
                print("Error occurred: \(error)")
            }
        }
    }
    
    @objc private func appleLoginTapped() {
        loginViewModel.performAppleLogin(presentationAnchor: view.window!)
    }
    
    @objc private func kakaoLoginTapped() {
        loginViewModel.performKakaoLogin(presentationAnchor: view.window!)
    }
}
