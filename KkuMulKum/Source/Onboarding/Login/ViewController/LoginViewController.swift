//
//  LoginVC.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

class LoginViewController: BaseViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    
    // 중복 네비게이션 방지를 위한 플래그
    private var isNavigating = false
    
    // MARK: - Initialization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupAction()
        
        // 자동 로그인 시도
        viewModel.autoLogin { success in
            if !success {
                print("Auto login failed")
            }
        }
    }
    
    // MARK: - Setup Methods
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
    
    private func setupBindings() {
        // 상태 변경 콜백
        viewModel.loginStateChanged = {state in
            print("Login state changed: \(state)")
            // 필요한 경우 UI 업데이트
        }
        
        // 로그인 결과 Pulse 구독
        viewModel.loginResultPulse.subscribe(with: self) { owner, result in
            switch result {
            case .success(let model):
                print("Login success with user: \(model.name ?? "no name")")
            case .failure(let error):
                print("Login failed with error: \(error)")
            }
        }
        
        // 네비게이션 Pulse 구독
        viewModel.navigationPulse.subscribe(with: self) { owner, navigation in
            // 중복 네비게이션 방지
            guard !owner.isNavigating else { return }
            owner.isNavigating = true
            
            switch navigation {
            case .toMain:
                owner.navigateToMainScreen()
            case .toOnboarding:
                owner.navigateToOnboardingScreen()
            case .showError(let message):
                owner.showErrorAlert(message: message)
            }
        }
    }
    
    // MARK: - Action Methods
    @objc private func appleLoginTapped() {
        guard let window = view.window else { return }
        viewModel.performAppleLogin(presentationAnchor: window)
    }
    
    @objc private func kakaoLoginTapped() {
        viewModel.performKakaoLogin()
    }
    
    // MARK: - Navigation Methods
    private func navigateToMainScreen() {
        let mainTabBarController = MainTabBarController()
        let navigationController = UINavigationController(
            rootViewController: mainTabBarController,
            isBorderNeeded: false
        )
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        
        // 네비게이션 완료 후 플래그 초기화
        present(navigationController, animated: true) { [weak self] in
            self?.isNavigating = false
        }
    }
    
    private func navigateToOnboardingScreen() {
        let nicknameViewController = NicknameViewController()
        
        if let navigationController = self.navigationController {
            // 네비게이션 컨트롤러가 있는 경우 push
            navigationController.pushViewController(nicknameViewController, animated: true)
            
            // 애니메이션 완료 후 플래그 초기화
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.isNavigating = false
            }
        } else {
            // 네비게이션 컨트롤러가 없는 경우 새로 생성
            let navigationController = UINavigationController(
                rootViewController: nicknameViewController,
                isBorderNeeded: false
            )
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            
            // 네비게이션 완료 후 플래그 초기화
            present(navigationController, animated: true) { [weak self] in
                self?.isNavigating = false
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        print("Showing error alert with message: \(message)")
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.isNavigating = false
        })
        present(alert, animated: true)
    }
}
