//
//  MyPageAlarmSettingView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class MyPageAlarmSettingView: BaseView {
    private let stackView = UIStackView(axis: .vertical).then {
        $0.spacing = 16
        $0.alignment = .leading
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("내 푸쉬 알림", style: .body03, color: .gray7)
    }
    
    private let toggleSwitch = UISwitch().then {
        $0.onTintColor = .green
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setText(
            "준비, 이동을 시작해야할 시간에\n푸시 알림을 받을 수 있습니다.",
            style: .caption02,
            color: .gray6
        )
    }
    
    override func setupView() {
        backgroundColor = .white
        layer.borderColor = UIColor.gray1.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        stackView.addArrangedSubviews(titleLabel, subtitleLabel)
        addSubviews(stackView, toggleSwitch)
    }
    
    override func setupAutoLayout() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
