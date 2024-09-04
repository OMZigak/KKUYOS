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
        addSubviews(backgroundImageView, appleLoginImageView, kakaoLoginImageView)
    }
    
    override func setupAutoLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        kakaoLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-194)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(Screen.height(54))
        }
        
        appleLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(kakaoLoginImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(Screen.height(54))
        }
    }
}
