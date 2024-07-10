//
//  WelcomeViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    private let welcomeView = WelcomeView()
    
    override func loadView() {
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        setupDelegate()
    }
    
    override func setupView() {
        // 배경색상 설정
        view.backgroundColor = .green2
    }
    
    override func setupAction() {
        welcomeView.confirmButton.addTarget(self, 
            action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func setupDelegate() {

    }
    
    @objc private func confirmButtonTapped() {
        print("확인 버튼이 탭되었습니다.")
    }
}
