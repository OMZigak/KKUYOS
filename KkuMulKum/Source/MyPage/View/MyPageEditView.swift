//
//  MyPageEditView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import UIKit

import SnapKit
import Then

class MyPageEditView: BaseView {
    let titleLabel = UILabel().then {
        $0.setText("프로필을 설정해 주세요", style: .head01, color: .gray8)
        $0.textAlignment = .left
    }
    
    let profileImageView = UIImageView().then {
        $0.image = .imgProfile
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let cameraButton = UIButton().then {
        $0.setImage(.iconCamera, for: .normal)
        $0.tintColor = .white
        $0.setLayer(borderWidth: 0, borderColor: .clear, cornerRadius: 15)
    }
    
    let skipButton = UIButton().then {
        $0.setTitle("기본 프로필로 설정", style: .body03, color: .gray5)
        $0.addUnderline()
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("확인", style: .body03, color: .white)
        $0.backgroundColor = .maincolor
        $0.setLayer(borderWidth: 0, borderColor: .clear, cornerRadius: 8)
    }
    
    override func setupView() {
        backgroundColor = .white
        
        addSubviews(titleLabel, profileImageView, cameraButton, skipButton, confirmButton)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(120)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Screen.width(150))
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(Screen.width(42))
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(50))
        }
    }
}
