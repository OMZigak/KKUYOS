//
//  MyPageContentView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then


class MyPageContentView: BaseView {
    
    let profileStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
        $0.alignment = .center
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage.imgEdit, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Screen.width(24) / 2
        $0.clipsToBounds = true
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage.imgProfile
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then {
        $0.setText("꾸물리안 님", style: .body01, color: .gray8)
    }
    
    let levelView = UIView(backgroundColor: .maincolor).then {
        $0.layer.cornerRadius = Screen.height(36) / 2
    }
    
    let levelLabel = UILabel().then {
        $0.setText("Lv. 1 지각대장 꾸물이", style: .body05, color: .white)
        $0.setHighlightText("Lv. 1", style: .body05, color: .lightGreen)
    }
    
    let separatorView = UIView(backgroundColor: .green2)
    
    override func setupView() {
        backgroundColor = .green1
        
        profileStackView.addArrangedSubviews(profileImageView, nameLabel)
        addSubviews(profileStackView, editButton, levelView, separatorView)
        levelView.addSubviews(levelLabel)
    }
    
    override func setupAutoLayout() {
        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(120))
        }
        
        profileImageView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(82))
            $0.width.equalTo(profileImageView.snp.height)
        }
        profileImageView.layer.cornerRadius = Screen.height(82) / 2
        
        editButton.snp.makeConstraints {
            $0.size.equalTo(Screen.width(24))
            $0.bottom.trailing.equalTo(profileImageView)
        }
        
        levelView.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(12)
            $0.height.equalTo(Screen.height(36))
            $0.leading.trailing.equalToSuperview().inset(83)
        }
        
        levelLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(6))
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(levelView.snp.bottom).offset(35)
            $0.bottom.equalToSuperview().offset(-25)
        }
    }
}
