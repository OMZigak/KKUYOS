//
//  MyPageAlarmSettingView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class AlarmSettingView: BaseView {
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.cornerRadius = 8
    }
    
    let titleLabel = UILabel().then {
        $0.text = "내 푸시 알림"
        $0.font = UIFont.pretendard(.body03)
        $0.textColor = .black
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "준비, 이동을 시작해야할 시간에\n푸시 알림을 받을 수 있습니다."
        $0.font = UIFont.pretendard(.caption02)
        $0.textColor = .gray
        $0.numberOfLines = 2
    }
    
    let toggleSwitch = UISwitch().then {
        $0.onTintColor = .green
    }
    
    override func setupView() {
        super.setupView()
        backgroundColor = .white
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(toggleSwitch)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
