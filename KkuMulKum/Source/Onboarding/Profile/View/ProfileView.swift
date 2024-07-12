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
        $0.text = "프로필 설정"
        $0.font = UIFont.pretendard(.body03)
        $0.textAlignment = .center
    }
    
    let separatorLine = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "프로필을 설정해 주세요"
        $0.font = UIFont.pretendard(.head01)
        $0.textColor = .gray8
        $0.textAlignment = .center
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage.imgProfile
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 75
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
    }
    
    let cameraButton = UIButton().then {
        $0.setImage(UIImage.iconCamera, for: .normal)
        $0.tintColor = .white
        $0.layer.cornerRadius = 15
    }
    
    let skipButton = UIButton().then {
        $0.setTitle("지금은 넘어가기", for: .normal)
        $0.setTitleColor(.gray5, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(.body05)
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = .maincolor
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.pretendard(.body03)
    }
    
    override func setupView() {
        backgroundColor = .white
        [navigationBar, separatorLine, subtitleLabel, profileImageView, cameraButton, skipButton, confirmButton].forEach { addSubview($0) }
        navigationBar.addSubview(titleLabel)
    }
    
    override func setupAutoLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(93)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(navigationBar.snp.centerX)
            $0.bottom.equalTo(navigationBar.snp.bottom).offset(-12)
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(120)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(150)
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(42)
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}
