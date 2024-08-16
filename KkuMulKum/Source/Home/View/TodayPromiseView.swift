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
    
    private let meetingNameView = UIStackView(axis: .horizontal).then {
        $0.backgroundColor = .green2
        $0.layer.cornerRadius = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let meetingNameLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let placeNameLabel = UILabel()
    
    let timeLabel = UILabel()
    
    private let placeView = UIStackView(axis: .horizontal).then {
        $0.spacing = 4
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let timeView = UIStackView(axis: .horizontal).then {
        $0.spacing = 4
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let infoView = UIStackView(axis: .horizontal).then {
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
    
    private let lineView = UIView(backgroundColor: .gray2)
    
    let prepareLineView = UIView(backgroundColor: .maincolor).then {
        $0.isHidden = true
    }
    
    let moveLineView = UIView(backgroundColor: .maincolor).then {
        $0.isHidden = true
    }
    
    let arriveLineView = UIView(backgroundColor: .maincolor).then {
        $0.isHidden = true
    }
    
    let prepareCircleView = UIView(backgroundColor: .maincolor).then {
        $0.layer.cornerRadius = 8
    }
    
    let moveCircleView = UIView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = 8
    }
    
    let arriveCircleView = UIView(backgroundColor: .gray2).then {
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
        $0.setTitle("준비 시작", style: .body05, color: .maincolor)
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
    
    let prepareTimeLabel = UILabel()
    
    let moveTimeLabel = UILabel()
    
    let arriveTimeLabel = UILabel()
    
    
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
            arriveCheckView,
            prepareTimeLabel,
            moveTimeLabel,
            arriveTimeLabel
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
            $0.top.bottom.equalToSuperview().inset(2)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(meetingNameView.snp.bottom).offset(4)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-80)
            $0.height.equalTo(4)
        }
        
        prepareButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-34)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        moveButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-34)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        arriveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-34)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        prepareLineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(prepareButton.snp.centerX)
            $0.bottom.equalToSuperview().offset(-80)
            $0.height.equalTo(4)
        }

        
        arriveLineView.snp.makeConstraints {
            $0.leading.equalTo(moveButton.snp.centerX)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-80)
            $0.height.equalTo(4)
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
        
        prepareTimeLabel.snp.makeConstraints {
            $0.bottom.equalTo(prepareCircleView.snp.top).offset(-12)
            $0.centerX.equalTo(prepareButton.snp.centerX)
        }
        
        moveTimeLabel.snp.makeConstraints {
            $0.bottom.equalTo(moveCircleView.snp.top).offset(-12)
            $0.centerX.equalTo(moveButton.snp.centerX)
        }
        
        arriveTimeLabel.snp.makeConstraints {
            $0.bottom.equalTo(arriveCircleView.snp.top).offset(-12)
            $0.centerX.equalTo(arriveButton.snp.centerX)
        }
    }
}
