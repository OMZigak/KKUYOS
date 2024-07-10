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
    
    let titleLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textAlignment = .center
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "프로필을 설정해 주세요"
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    
    let cameraButton = UIButton().then {
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 15
    }
    
    let skipButton = UIButton().then {
        $0.setTitle("지금은 넘어가기", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = .maincolor
        $0.layer.cornerRadius = 8
    }
    
    override func setupView() {
        backgroundColor = .white
        [titleLabel, subtitleLabel, profileImageView, cameraButton, skipButton, confirmButton].forEach { addSubview($0) }
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(30)
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}
