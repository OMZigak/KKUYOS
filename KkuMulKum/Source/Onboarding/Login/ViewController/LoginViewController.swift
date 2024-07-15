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
        print("LoginViewController loadView called")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController viewDidLoad called")
        bindViewModel()
        setupAction()
    }
    
    override func setupAction() {
        super.setupAction()
        print("Setting up actions for LoginViewController")
        
        let appleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(appleLoginTapped)
        )
        loginView.appleLoginImageView.addGestureRecognizer(appleTapGesture)
        
        let kakaoTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(kakaoLoginTapped)
        )
        loginView.kakaoLoginImageView.addGestureRecognizer(kakaoTapGesture)
        
        loginView.dummyNextButton.addTarget(
            self,
            action: #selector(dummyNextButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        print("Binding ViewModel in LoginViewController")
        loginViewModel.loginState.bind(with: self) { owner, state in
            switch state {
            case .notLoggedIn:
                print("Login State: Not logged in")
            case .loggedIn(let userInfo):
                print("Login State: Logged in with user info: \(userInfo)")
                owner.navigateToMainScreen()
            case .needOnboarding:
                print("Login State: Need onboarding")
                owner.navigateToOnboardingScreen()
            }
        }
        
        loginViewModel.error.bind(with: self) { owner, error in
            if !error.isEmpty {
                print("Login Error: \(error)")
                owner.showErrorAlert(message: error)
            }
        }
    }
    
    @objc private func appleLoginTapped() {
        print("Apple Login button tapped")
        loginViewModel.performAppleLogin(presentationAnchor: view.window!)
    }
    
    @objc private func kakaoLoginTapped() {
        print("Kakao Login button tapped")
        loginViewModel.performKakaoLogin()
    }

    @objc private func dummyNextButtonTapped() {
        print("Dummy Next button tapped")
        let viewController = NicknameViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func navigateToMainScreen() {
        print("Navigating to Main Screen")
        // TODO: Implement navigation to main screen
    }
    
    private func navigateToOnboardingScreen() {
        print("Navigating to Onboarding Screen")
        // TODO: Implement navigation to onboarding screen
    }
    
    private func showErrorAlert(message: String) {
        print("Showing error alert with message: \(message)")
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
