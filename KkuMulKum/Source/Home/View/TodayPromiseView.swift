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
        $0.layer.cornerRadius = 12
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let meetingNameLabel = UILabel().then {
        $0.setText("꾸물이들", style: .caption02, color: .green3)
    }
    
    private let nameLabel = UILabel().then {
        $0.setText("리프레쉬 데이", style: .body03, color: .gray8)
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
        $0.setText("용산역", style: .body06, color: .gray7)
    }
    
    private let timeLabel = UILabel().then {
        $0.setText("PM 2:00", style: .body06, color: .gray7)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    let prepareLineView = UIView().then {
        $0.backgroundColor = .maincolor
        $0.isHidden = true
    }
    
    let moveLineView = UIView().then {
        $0.backgroundColor = .maincolor
        $0.isHidden = true
    }
    
    let arriveLineView = UIView().then {
        $0.backgroundColor = .maincolor
        $0.isHidden = true
    }
    
    let prepareCircleView = UIView().then {
        $0.backgroundColor = .gray2
        $0.layer.cornerRadius = 8
    }
    
    let moveCircleView = UIView().then {
        $0.backgroundColor = .gray2
        $0.layer.cornerRadius = 8
    }
    
    let arriveCircleView = UIView().then {
        $0.backgroundColor = .gray2
        $0.layer.cornerRadius = 8
    }
    
    let prepareCheckView = UIImageView().then {
        $0.image = .iconCheck
        $0.isHidden = true
    }
    
    let moveCheckView = UIImageView().then {
        $0.image = .iconCheck
        $0.isHidden = true
    }
    
    let arriveCheckView = UIImageView().then {
        $0.image = .iconCheck
        $0.isHidden = true
    }
    
    let prepareButton = UIButton().then {
        $0.setTitle("준비 중", style: .body05, color: .maincolor)
        $0.setLayer(borderWidth: 1, borderColor: .maincolor, cornerRadius: 16)
    }
    
    let moveButton = UIButton().then {
        $0.setTitle("이동 시작", style: .body05, color: .gray4)
        $0.setLayer(borderWidth: 1, borderColor: .gray4, cornerRadius: 16)
        $0.isEnabled = false
    }
    
    let arriveButton = UIButton().then {
        $0.setTitle("도착 완료", style: .body05, color: .gray4)
        $0.setLayer(borderWidth: 1, borderColor: .gray4, cornerRadius: 16)
        $0.isEnabled = false
    }
    
    let prepareLabel = UILabel().then {
        $0.setText("준비를 시작 시 눌러주세요", style: .label02, color: .gray5)
        $0.isHidden = false
    }
    
    let moveLabel = UILabel().then {
        $0.setText("이동를 시작 시 눌러주세요", style: .label02, color: .gray5)
        $0.isHidden = true
    }
    
    let arriveLabel = UILabel().then {
        $0.setText("도착 완료 시 눌러주세요", style: .label02, color: .gray5)
        $0.isHidden = true
    }
    
    
    // MARK: - UI Setting

    override func setupView() {
        addSubviews(
            meetingNameView,
            nameLabel,
            infoView,
            lineView,
            prepareLineView,
            moveLineView,
            arriveLineView,
            prepareButton,
            moveButton,
            arriveButton,
            prepareLabel,
            moveLabel,
            arriveLabel,
            prepareCircleView,
            moveCircleView,
            arriveCircleView,
            prepareCheckView,
            moveCheckView,
            arriveCheckView
        )
        meetingNameView.addSubviews(meetingNameLabel)
        infoView.addArrangedSubviews(placeView, timeView)
        placeView.addArrangedSubviews(placeIcon, placeNameLabel)
        timeView.addArrangedSubviews(timeIcon, timeLabel)
    }
    
    override func setupAutoLayout() {
        meetingNameView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(26)
        }
        
        meetingNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(4)
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
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(168)
            $0.height.equalTo(4)
        }
        
        prepareButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(188)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        moveButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(188)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        prepareLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(prepareButton.snp.centerX)
            $0.top.equalToSuperview().offset(168)
            $0.height.equalTo(4)
        }
        
        moveLineView.snp.makeConstraints {
            $0.leading.equalTo(prepareButton.snp.centerX)
            $0.trailing.equalTo(moveButton.snp.centerX)
            $0.top.equalToSuperview().offset(168)
            $0.height.equalTo(4)
        }
        
        arriveLineView.snp.makeConstraints {
            $0.leading.equalTo(moveButton.snp.centerX)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(168)
            $0.height.equalTo(4)
        }
        
        arriveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(188)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        timeIcon.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        placeIcon.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        prepareCircleView.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.centerX.equalTo(prepareButton.snp.centerX)
            $0.size.equalTo(16)
        }
        
        moveCircleView.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.centerX.equalTo(moveButton.snp.centerX)
            $0.size.equalTo(16)
        }
        
        arriveCircleView.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.centerX.equalTo(arriveButton.snp.centerX)
            $0.size.equalTo(16)
        }
        
        prepareCheckView.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.centerX.equalTo(prepareButton.snp.centerX)
            $0.size.equalTo(16)
        }
        
        moveCheckView.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.centerX.equalTo(moveButton.snp.centerX)
            $0.size.equalTo(16)
        }
        
        arriveCheckView.snp.makeConstraints {
            $0.centerY.equalTo(lineView.snp.centerY)
            $0.centerX.equalTo(arriveButton.snp.centerX)
            $0.size.equalTo(16)
        }
        
        prepareLabel.snp.makeConstraints {
            $0.top.equalTo(prepareButton.snp.bottom).offset(6)
            $0.centerX.equalTo(prepareButton.snp.centerX)
        }
        
        moveLabel.snp.makeConstraints {
            $0.top.equalTo(moveButton.snp.bottom).offset(6)
            $0.centerX.equalTo(moveButton.snp.centerX)
        }
        
        arriveLabel.snp.makeConstraints {
            $0.top.equalTo(arriveButton.snp.bottom).offset(6)
            $0.centerX.equalTo(arriveButton.snp.centerX)
        }
    }
}
