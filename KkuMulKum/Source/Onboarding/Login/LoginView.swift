//
//  LoginView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class LoginView: UIView {
    
    let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "")
    }
    
    let titleLabel = UILabel().then {
        $0.text = "꾸물꿈"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(appleLoginImageView)
        addSubview(kakaoLoginImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(kakaoLoginImageView.snp.top).offset(-20)
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(54)
        }
        
        kakaoLoginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-50)
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo(54)
        }
    }
}
