//
//  LoginVC.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

class LoginViewController: BaseViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 여기에 필요한 설정이나 로직을 추가할 수 있습니다.
    }
    
    override func setupAction() {
        super.setupAction()
        
        let appleTapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginTapped))
        loginView.appleLoginImageView.addGestureRecognizer(appleTapGesture)
        
        let kakaoTapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginTapped))
        loginView.kakaoLoginImageView.addGestureRecognizer(kakaoTapGesture)
    }
    
    @objc private func appleLoginTapped() {
        // Apple 로그인 처리
    }
    
    @objc private func kakaoLoginTapped() {
        // 카카오 로그인 처리
    }
}
