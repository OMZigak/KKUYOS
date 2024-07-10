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
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let stackView = UIStackView(axis: .vertical).then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let titleStackView = UIStackView(axis: .horizontal).then {
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "내 푸시 알림"
        $0.font = UIFont.pretendard(.body03)
        $0.textColor = .black
    }
    
    private let toggleSwitch = UISwitch().then {
        $0.onTintColor = .green
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setText("준비, 이동을 시작해야할 시간에\n푸시 알림을 받을 수 있습니다.", style: .caption02, color: .gray)
    }
    
    override func setupView() {
        super.setupView()
        backgroundColor = .systemMint.withAlphaComponent(0.1)
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        titleStackView.addArrangedSubviews(titleLabel, toggleSwitch)
        stackView.addArrangedSubviews(titleStackView, subtitleLabel)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        titleStackView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.width.equalTo(51)
            $0.height.equalTo(31)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(40) // 최소 높이 설정
        }
    }
}
