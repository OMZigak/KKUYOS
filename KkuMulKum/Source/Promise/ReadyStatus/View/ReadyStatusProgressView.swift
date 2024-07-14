//
//  ReadyStatusProgressView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import UIKit

class ReadyStatusProgressView: BaseView {
    private let statusProgressView: UIProgressView = UIProgressView().then {
        $0.trackTintColor = .gray2
        $0.progressTintColor = .maincolor
    }
    
    private let readyStartTimeLabel: UILabel = UILabel().then {
        $0.setText("AM hh:mm", style: .caption02, color: .gray8)
    }
    
    private let readyStartCheckImageView: UIImageView = UIImageView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = Screen.height(16 / 2)
        $0.clipsToBounds = true
    }
    
    private let readyStartButton: ReadyStatusButton = ReadyStatusButton(
        title: "준비 중",
        readyStatus: .none
    ).then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
    }
    
    private let readyStartTitleLabel: UILabel = UILabel().then {
        $0.setText("준비를 시작 시 눌러주세요", style: .label02, color: .gray5)
    }
    
    private let moveStartTimeLabel: UILabel = UILabel().then {
        $0.setText("AM hh:mm", style: .caption02, color: .gray8)
    }
    
    private let moveStartCheckImageView: UIImageView = UIImageView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = Screen.height(16 / 2)
        $0.clipsToBounds = true
    }
    
    private let moveStartButton: ReadyStatusButton = ReadyStatusButton(
        title: "이동 시작",
        readyStatus: .none
    ).then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
    }
    
    private let moveStartTitleLabel: UILabel = UILabel().then {
        $0.setText("이동을 시작 시 눌러주세요", style: .label02, color: .gray5)
    }
    
    private let arrivalTimeLabel: UILabel = UILabel().then {
        $0.setText("AM hh:mm", style: .caption02, color: .gray8)
    }
    
    private let arrivalCheckImageView: UIImageView = UIImageView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = Screen.height(16 / 2)
        $0.clipsToBounds = true
    }
    
    private let arrivalButton: ReadyStatusButton = ReadyStatusButton(
        title: "도착 완료",
        readyStatus: .none
    ).then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
    }
    
    private let arrivalTitleLabel: UILabel = UILabel().then {
        $0.setText("도착 시작 시 눌러주세요", style: .label02, color: .gray5)
    }
    
    override func setupView() {
        backgroundColor = .white
        
        addSubviews(
            statusProgressView,
            readyStartTimeLabel,
            readyStartCheckImageView,
            readyStartButton,
            readyStartTitleLabel,
            moveStartTimeLabel,
            moveStartCheckImageView,
            moveStartButton,
            moveStartTitleLabel,
            arrivalTimeLabel,
            arrivalCheckImageView,
            arrivalButton,
            arrivalTitleLabel
        )
    }
    
    override func setupAutoLayout() {
        statusProgressView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.horizontalEdges.equalToSuperview().inset(-4)
            $0.height.equalTo(Screen.height(5))
        }
        
        readyStartCheckImageView.snp.makeConstraints {
            $0.centerY.equalTo(statusProgressView)
            $0.leading.equalToSuperview().offset(53.5)
            $0.height.equalTo(Screen.height(16))
            $0.width.equalTo(readyStartCheckImageView.snp.height)
        }
        
        readyStartButton.snp.makeConstraints {
            $0.top.equalTo(readyStartCheckImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(readyStartCheckImageView)
            $0.height.equalTo(Screen.height(32))
            $0.width.equalTo(Screen.width(84))
        }
        
        readyStartTimeLabel.snp.makeConstraints {
            $0.bottom.equalTo(statusProgressView).offset(-18.5)
            $0.centerX.equalTo(readyStartCheckImageView)
        }
        
        readyStartTitleLabel.snp.makeConstraints {
            $0.top.equalTo(readyStartButton.snp.bottom).offset(9)
            $0.centerX.equalTo(readyStartCheckImageView)
        }
        
        moveStartTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(readyStartTimeLabel)
        }
        
        moveStartCheckImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(readyStartCheckImageView)
            $0.height.equalTo(Screen.height(16))
            $0.width.equalTo(moveStartCheckImageView.snp.height)
        }
        
        moveStartButton.snp.makeConstraints {
            $0.top.equalTo(moveStartCheckImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(moveStartCheckImageView)
            $0.height.equalTo(Screen.height(32))
            $0.width.equalTo(Screen.width(84))
        }
        
        moveStartTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(readyStartTitleLabel)
        }
        
        arrivalTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(38)
            $0.centerY.equalTo(readyStartTimeLabel)
        }
        
        arrivalCheckImageView.snp.makeConstraints {
            $0.centerX.equalTo(arrivalTimeLabel)
            $0.centerY.equalTo(readyStartCheckImageView)
            $0.height.equalTo(Screen.height(16))
            $0.width.equalTo(arrivalCheckImageView.snp.height)
        }
        
        arrivalButton.snp.makeConstraints {
            $0.top.equalTo(arrivalCheckImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(arrivalCheckImageView)
            $0.height.equalTo(Screen.height(32))
            $0.width.equalTo(Screen.width(84))
        }
        
        arrivalTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(arrivalCheckImageView)
            $0.centerY.equalTo(readyStartTitleLabel)
            $0.bottom.equalToSuperview().inset(17)
        }
    }
}
