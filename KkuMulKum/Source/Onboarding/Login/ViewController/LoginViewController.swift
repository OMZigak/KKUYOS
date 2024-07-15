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
    
    init() {
        let authService = AuthService()
        self.loginViewModel = LoginViewModel(authService: authService)
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
        
        let appleTapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginTapped))
        loginView.appleLoginImageView.addGestureRecognizer(appleTapGesture)
        
        let kakaoTapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginTapped))
        loginView.kakaoLoginImageView.addGestureRecognizer(kakaoTapGesture)
        
        loginView.dummyNextButton.addTarget(self, action: #selector(dummyNextButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        loginViewModel.loginState.bind(with: self) { owner, state in
            switch state {
            case .notLoggedIn:
                print("Not logged in")
            case .loggedIn(let userInfo):
                print("Logged in: \(userInfo)")
                owner.navigateToMainScreen()
            }
        }
        
        loginViewModel.error.bind(with: self) { owner, error in
            if !error.isEmpty {
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
    
    // TODO: 추후 서버연결후 삭제예정
    @objc private func dummyNextButtonTapped() {
        //        _ = NicknameViewController()
        //        let welcomeViewController = NicknameViewController()
        //        welcomeViewController.modalPresentationStyle = .fullScreen
        //        present(welcomeViewController, animated: true, completion: nil)
        
        // TODO: 프로필 설정부터 네비게이션으로 플로우 동작
        
        let viewController = MainTabBarController()
        
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
    
    private func navigateToMainScreen() {
        // 로그인 성공 후 메인 화면으로 이동하는 로직
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
