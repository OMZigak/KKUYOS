//
//  WelcomeViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class WelcomeViewController: BaseViewController {
    private let welcomeView = WelcomeView()
    private let viewModel: WelcomeViewModel
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        updateWelcomeLabel()
    }
    
    override func setupView() {
        view.backgroundColor = .green2
        welcomeView.backgroundColor = .green1
    }
    
    private func setupActions() {
        welcomeView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func updateWelcomeLabel() {
        welcomeView.configure(with: viewModel.nickname.value)
    }
    
    @objc private func confirmButtonTapped() {
        let mainTabBarController = MainTabBarController()
        
        let navigationController = UINavigationController(rootViewController: mainTabBarController)
        
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
}
