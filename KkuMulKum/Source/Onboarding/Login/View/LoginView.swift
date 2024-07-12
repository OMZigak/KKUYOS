//
//  LoginView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class LoginView: BaseView {
    
    let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = .imgLogin
    }
    
    // TODO: 서버 연결후 삭제예정
    let dummyNextButton = UIButton().then {
        $0.setTitle("다음 화면으로 (서버연결후 삭제예정)", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 8
    }
    
    let appleLoginImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "appleLogin")
        $0.isUserInteractionEnabled = true
    }
    
    let kakaoLoginImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "kakaoLogin")
        $0.isUserInteractionEnabled = true
    }
    
    override func setupView() {
        addSubviews(backgroundImageView, appleLoginImageView, kakaoLoginImageView, dummyNextButton)
    }
    
    override func setupAutoLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        appleLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(kakaoLoginImageView.snp.top).offset(20)
            $0.width.equalToSuperview().offset(-Screen.width(40))
            $0.height.equalTo(Screen.height(54))
        }
        
        kakaoLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(50)
            $0.width.equalToSuperview().offset(40)
            $0.height.equalTo(Screen.height(54))
        }
        
        dummyNextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(kakaoLoginImageView.snp.bottom).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
    }
}
