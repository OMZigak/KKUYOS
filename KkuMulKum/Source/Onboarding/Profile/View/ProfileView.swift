//
//  ProfileVIew.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class ProfileSetupView: BaseView {
    
    let navigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    let titleLabel = UILabel().then {
        $0.setText("프로필 설정", style: .body03, color: .gray8)
        $0.textAlignment = .center
    }
    
    let separatorLine = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    let subtitleLabel = UILabel().then {
        $0.setText("프로필을 설정해 주세요", style: .head01, color: .gray8)
        $0.textAlignment = .center
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage.imgProfile
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
     //   $0.setLayer(borderWidth: 1, borderColor: .gray3, cornerRadius: Screen.width(75))
    }
    
    let cameraButton = UIButton().then {
        $0.setImage(UIImage.iconCamera, for: .normal)
        $0.tintColor = .white
        $0.setLayer(borderWidth: 0, borderColor: .clear, cornerRadius: 15)
    }
    
    let skipButton = UIButton().then {
        $0.setTitle("지금은 넘어가기", style: .body05, color: .gray5)
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("확인", style: .body03, color: .white)
        $0.backgroundColor = .maincolor
        $0.setLayer(borderWidth: 0, borderColor: .clear, cornerRadius: 8)
    }
    
    override func setupView() {
        backgroundColor = .white
        addSubviews(navigationBar, separatorLine, subtitleLabel, profileImageView, cameraButton, skipButton, confirmButton)
        navigationBar.addSubview(titleLabel)
    }
    
    override func setupAutoLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(93))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(navigationBar.snp.centerX)
            $0.bottom.equalTo(navigationBar.snp.bottom).offset(-Screen.height(12))
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(Screen.height(24))
            $0.leading.trailing.equalToSuperview().inset(Screen.width(20))
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Screen.height(120))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Screen.width(150))
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(Screen.width(42))
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-Screen.height(20))
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-Screen.height(20))
            $0.leading.trailing.equalToSuperview().inset(Screen.width(20))
            $0.height.equalTo(Screen.height(50))
        }
    }
}
