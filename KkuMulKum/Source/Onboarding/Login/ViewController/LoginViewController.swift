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
    
    init(viewModel: LoginViewModel) {
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
            action: #selector(appleLoginTapped)
        )
        loginView.appleLoginImageView.addGestureRecognizer(appleTapGesture)
        
        let kakaoTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(kakaoLoginTapped)
        )
        loginView.kakaoLoginImageView.addGestureRecognizer(kakaoTapGesture)
    }
    
    private func bindViewModel() {
        loginViewModel.userName.bind(with: self) { owner, name in
            Task {
                if name != nil {
                    await owner.navigateToMainScreen()
                } else {
                    await owner.navigateToOnboardingScreen()
                }
            }
        }
        
        loginViewModel.error.bind(with: self) { owner, error in
            Task {
                if !error.isEmpty {
                    print("Login Error: \(error)")
                    await owner.showErrorAlert(message: error)
                }
            }
        }
    }
    
    @objc private func appleLoginTapped() {
        Task {
            loginViewModel.performAppleLogin(presentationAnchor: view.window!)
        }
    }
    
    @objc private func kakaoLoginTapped() {
        Task {
            loginViewModel.performKakaoLogin()
        }
    }
    
    private func navigateToMainScreen() async {
        await MainActor.run {
            let mainTabBarController = MainTabBarController()
            let navigationController = UINavigationController(
                rootViewController: mainTabBarController,
                isBorderNeeded: true
            )
            navigationController.isNavigationBarHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func navigateToOnboardingScreen() async {
        await MainActor.run {
            
            let nicknameViewController = NicknameViewController()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(nicknameViewController, animated: true)
            } else {
                let navigationController = UINavigationController(
                    rootViewController: nicknameViewController,
                    isBorderNeeded: true
                )
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .crossDissolve
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    private func showErrorAlert(message: String) async {
        await MainActor.run {
            print("Showing error alert with message: \(message)")
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
