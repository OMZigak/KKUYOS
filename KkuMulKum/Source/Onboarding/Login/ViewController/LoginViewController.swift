//
//  LoginVC.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

class LoginViewController: BaseViewController {
    private let loginView = LoginView()
    private let loginViewModel: LoginViewModel

    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.loginViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupAction()
    }
    
    override func setupAction() {
        super.setupAction()
        
        let appleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(
                appleLoginTapped
            )
        )
        loginView.appleLoginImageView.addGestureRecognizer(
            appleTapGesture
        )
        
        let kakaoTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(
                kakaoLoginTapped
            )
        )
        loginView.kakaoLoginImageView.addGestureRecognizer(kakaoTapGesture)

        loginView.dummyNextButton.addTarget(
            self,
            action: #selector(dummyNextButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        loginViewModel.loginState.bind(with: self) { owner, state in
            switch state {
            case .notLogin:
                print("Login State: Not logged in")
            case .login:
                print("Login State: Logged in with user info: ")
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
        loginViewModel.performAppleLogin(presentationAnchor: view.window!)
    }
    
    @objc private func kakaoLoginTapped() {
        loginViewModel.performKakaoLogin()
    }
   
    @objc private func dummyNextButtonTapped() {
        let viewController = MainTabBarController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    private func navigateToMainScreen() {
        DispatchQueue.main.async {
            let mainTabBarController = MainTabBarController()
            let navigationController = UINavigationController(rootViewController: mainTabBarController)
            navigationController.isNavigationBarHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func navigateToOnboardingScreen() {
        DispatchQueue.main.async {
            let nicknameViewController = NicknameViewController()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(nicknameViewController, animated: true)
            } else {
                let navigationController = UINavigationController(rootViewController: nicknameViewController)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .crossDissolve
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        print("Showing error alert with message: \(message)")
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
