//
//  PromiseInfoView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class PromiseInfoView: BaseView {
    
    
    // MARK: Property
    
    let promiseImageView: UIImageView = UIImageView(image: .imgPromise)
    
    let dDayLabel: UILabel = UILabel().then {
        $0.setText("D-n", style: .body05, color: .gray5)
    }
    
    let promiseNameLabel: UILabel = UILabel().then {
        $0.setText("약속 이름을 설정해주세요", style: .body01, color: .gray7)
    }
    
    let editButton: UIButton = UIButton().then {
        $0.setTitle("수정하기", style: .caption01, color: .maincolor)
        $0.layer.cornerRadius = Screen.height(8)
        $0.backgroundColor = .white
    }

    let participantNumberLabel: UILabel = UILabel().then {
        $0.setText("약속 참여 인원 n명", style: .body05, color: .maincolor)
        $0.setHighlightText("n명", style: .body05, color: .gray3)
    }
    
    let participantCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
    }).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        $0.register(
            ParticipantCollectionViewCell.self,
            forCellWithReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier
        )
    }
    
    let locationContentLabel: UILabel = UILabel().then {
        $0.setText("sss역 s번 출구", style: .body04, color: .gray7)
    }
    
    let timeContentLabel: UILabel = UILabel().then {
        $0.setText("mm월 dd일 hh:mm", style: .body04, color: .gray7)
    }
    
    let readyLevelContentLabel: UILabel = UILabel().then {
        $0.setText("LV n. sss", style: .body04, color: .gray7)
    }
    
    let penaltyLevelContentLabel: UILabel = UILabel().then {
        $0.setText("ssss하기", style: .body04, color: .gray7)
    }
    
    private let backgroundView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Screen.height(18)
    }
    
    let locationInfoLabel: UILabel = UILabel().then {
        $0.setText("위치", style: .body05, color: .maincolor)
    }
    
    private let locationBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    let timeInfoLabel: UILabel = UILabel().then {
        $0.setText("약속시간", style: .body05, color: .maincolor)
    }
    
    private let timeBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    let readyLevelInfoLabel: UILabel = UILabel().then {
        $0.setText("꾸레벨", style: .body05, color: .maincolor)
    }
    
    private let readyLevelBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    let penaltyLevelInfoLabel: UILabel = UILabel().then {
        $0.setText("벌칙", style: .body05, color: .maincolor)
    }
    
    private let penaltyBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        addSubviews(
            promiseImageView,
            dDayLabel,
            promiseNameLabel,
            editButton,
            backgroundView
        )
        
        backgroundView.addSubviews(
            participantNumberLabel,
            participantCollectionView,
            locationInfoLabel,
            locationBackgroundView,
            locationContentLabel,
            timeInfoLabel,
            timeBackgroundView,
            timeContentLabel,
            readyLevelInfoLabel,
            readyLevelBackgroundView,
            readyLevelContentLabel,
            penaltyLevelInfoLabel,
            penaltyBackgroundView,
            penaltyLevelContentLabel
        )
    }
    
    override func setupAutoLayout() {
        promiseImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(31)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(Screen.height(48))
            $0.width.equalTo(promiseImageView.snp.height)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalTo(promiseImageView)
            $0.leading.equalTo(promiseImageView.snp.trailing).offset(16)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(promiseImageView)
            $0.height.equalTo(Screen.height(30))
            $0.width.equalTo(Screen.width(69))
            $0.trailing.equalToSuperview().inset(20)
        }
        
        promiseNameLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).inset(2)
            $0.leading.equalTo(dDayLabel)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(promiseImageView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        participantNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
        }
        
        participantCollectionView.snp.makeConstraints {
            $0.top.equalTo(participantNumberLabel.snp.bottom).offset(8.5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(88))
        }
        
        locationInfoLabel.snp.makeConstraints {
            $0.top.equalTo(participantCollectionView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        locationBackgroundView.snp.makeConstraints {
            $0.top.equalTo(locationInfoLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(53))
        }
        
        locationContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationBackgroundView)
            $0.horizontalEdges.equalTo(locationBackgroundView).inset(8)
        }
        
        timeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(locationBackgroundView.snp.bottom).offset(12)
            $0.leading.equalTo(locationBackgroundView)
        }
        
        timeBackgroundView.snp.makeConstraints {
            $0.top.equalTo(timeInfoLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(53))
        }
        
        timeContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeBackgroundView)
            $0.horizontalEdges.equalTo(timeBackgroundView).inset(8)
        }
        
        readyLevelInfoLabel.snp.makeConstraints {
            $0.top.equalTo(timeBackgroundView.snp.bottom).offset(12)
            $0.leading.equalTo(timeBackgroundView)
        }
        
        readyLevelBackgroundView.snp.makeConstraints {
            $0.top.equalTo(readyLevelInfoLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(53))
        }
        
        readyLevelContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(readyLevelBackgroundView)
            $0.horizontalEdges.equalTo(readyLevelBackgroundView).inset(8)
        }
        
        penaltyLevelInfoLabel.snp.makeConstraints {
            $0.top.equalTo(readyLevelBackgroundView.snp.bottom).offset(12)
            $0.leading.equalTo(timeBackgroundView)
        }
        
        penaltyBackgroundView.snp.makeConstraints {
            $0.top.equalTo(penaltyLevelInfoLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(53))
        }
        
        penaltyLevelContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(penaltyBackgroundView)
            $0.horizontalEdges.equalTo(readyLevelBackgroundView).inset(8)
        }
    }
}
