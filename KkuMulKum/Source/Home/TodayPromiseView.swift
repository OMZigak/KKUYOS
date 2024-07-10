//
//  TodayPromiseView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/10/24.
//

import UIKit

import SnapKit
import Then


final class TodayPromiseView: BaseView {
    
    
    // MARK: - Property
    
    private let meetingNameView = UIStackView().then {
        $0.backgroundColor = .green2
        $0.layer.cornerRadius = 10
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let meetingNameLabel = UILabel().then {
        $0.text = "꾸물이들"
        $0.textColor = .green3
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.caption02)
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "리프레쉬 데이"
        $0.textColor = .gray8
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body03)
    }
    
    private let placeView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let timeView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let infoView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let placeIcon = UIImageView().then {
        $0.image = .iconPin
    }
    
    private let timeIcon = UIImageView().then {
        $0.image = .iconTime
    }
    
    private let placeNameLabel = UILabel().then {
        $0.text = "용산역"
        $0.textColor = .gray7
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body06)
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "PM 2:00"
        $0.textColor = .gray7
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body06)
    }

    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setting

    /// UI 설정 (addSubView 등)
    override func setupView() {
        addSubviews(meetingNameView, nameLabel, infoView)
        meetingNameView.addSubviews(meetingNameLabel)
        infoView.addArrangedSubviews(placeView, timeView)
        placeView.addArrangedSubviews(placeIcon, placeNameLabel)
        timeView.addArrangedSubviews(timeIcon, timeLabel)
    }
    
    /// 오토레이아웃 설정 (SnapKit 코드)
    override func setupAutoLayout() {
        meetingNameView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(26)
        }
        
        meetingNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(2)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(54)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(88)
            $0.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        timeIcon.snp.makeConstraints {
            //$0.top.equalToSuperview()
            //$0.leading.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
//        timeLabel.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview()
//        }
        
        placeIcon.snp.makeConstraints {
            //$0.top.equalToSuperview()
            //$0.leading.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
//        placeNameLabel.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview()
//        }
    }
}
