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
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "img_profile")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.pretendard(.body01)
        $0.textColor = .gray8
        $0.text = "꾸물리안 님"
    }
    
    let levelView = UIView().then {
        $0.backgroundColor = .maincolor
        $0.layer.cornerRadius = 20
    }
    
    let levelLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.pretendard(.body02)
        $0.text = "Lv. 1 지각대장 꾸물이"
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = .green2
    }
    
    override func setupView() {
        backgroundColor = .clear
        addSubviews(profileStackView,levelView,separatorView)
        profileStackView.addArrangedSubviews(profileImageView, nameLabel)
        levelView.addSubview(levelLabel)
    }
   
    override func setupAutoLayout() {
        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
        }
        
        levelView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.height.equalTo(36)
            $0.leading.trailing.equalToSuperview().inset(80)
        }
        
        levelLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(levelView.snp.bottom).offset(35)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
