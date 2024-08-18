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
        $0.setText("약속 이름이 설정되지 않았어요!", style: .body01, color: .gray7)
    }

    let participantNumberLabel: UILabel = UILabel().then {
        $0.setText("약속 참여 인원 n명", style: .body05, color: .maincolor)
        $0.setHighlightText("n명", style: .body05, color: .gray3)
    }
    
    let participantCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 12
            $0.estimatedItemSize = .init(width: Screen.width(68), height: Screen.height(88))
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
    
    private let locationInfoLabel: UILabel = UILabel().then {
        $0.setText("위치", style: .body05, color: .maincolor)
    }
    
    private let locationDivideView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let timeInfoLabel: UILabel = UILabel().then {
        $0.setText("약속시간", style: .body05, color: .maincolor)
    }
    
    private let timeDivideView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let readyLevelInfoLabel: UILabel = UILabel().then {
        $0.setText("꾸레벨", style: .body05, color: .maincolor)
    }
    
    private let readyLevelDivideView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let penaltyLevelInfoLabel: UILabel = UILabel().then {
        $0.setText("벌칙", style: .body05, color: .maincolor)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        addSubviews(
            promiseImageView,
            dDayLabel,
            promiseNameLabel,
            backgroundView
        )
        
        backgroundView.addSubviews(
            participantNumberLabel,
            participantCollectionView,
            locationInfoLabel,
            locationContentLabel,
            locationDivideView,
            timeInfoLabel,
            timeContentLabel,
            timeDivideView,
            readyLevelInfoLabel,
            readyLevelContentLabel,
            readyLevelDivideView,
            penaltyLevelInfoLabel,
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
        
        promiseNameLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).inset(2)
            $0.leading.equalTo(dDayLabel)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(promiseImageView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        participantNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
        }
        
        participantCollectionView.snp.makeConstraints {
            $0.top.equalTo(participantNumberLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(88))
        }
        
        locationInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(12)
        }
        
        locationContentLabel.snp.makeConstraints {
            $0.top.equalTo(locationInfoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(locationInfoLabel)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        locationDivideView.snp.makeConstraints {
            $0.top.equalTo(locationContentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(Screen.height(1))
        }
        
        timeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(locationDivideView.snp.top).offset(14)
            $0.leading.equalTo(locationDivideView)
        }
        
        timeContentLabel.snp.makeConstraints {
            $0.top.equalTo(timeInfoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(timeInfoLabel)
        }
        
        timeDivideView.snp.makeConstraints {
            $0.top.equalTo(timeContentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(Screen.height(1))
        }
        
        readyLevelInfoLabel.snp.makeConstraints {
            $0.top.equalTo(timeDivideView.snp.top).offset(14)
            $0.leading.equalTo(timeDivideView)
        }
        
        readyLevelContentLabel.snp.makeConstraints {
            $0.top.equalTo(readyLevelInfoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(readyLevelInfoLabel)
        }
        
        readyLevelDivideView.snp.makeConstraints {
            $0.top.equalTo(readyLevelContentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(Screen.height(1))
        }
        
        penaltyLevelInfoLabel.snp.makeConstraints {
            $0.top.equalTo(readyLevelDivideView.snp.top).offset(14)
            $0.leading.equalTo(timeDivideView)
        }
        
        penaltyLevelContentLabel.snp.makeConstraints {
            $0.top.equalTo(penaltyLevelInfoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(penaltyLevelInfoLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
