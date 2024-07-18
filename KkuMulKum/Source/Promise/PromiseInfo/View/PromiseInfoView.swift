//
//  PromiseInfoView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class PromiseInfoView: BaseView {
    
    
    // MARK: Property

    let participantNumberLabel: UILabel = UILabel().then {
        $0.setText("약속 참여 인원 n명", style: .body01)
        $0.setHighlightText("n명", style: .body01, color: .maincolor)
    }
    
    private let chevronButton: UIButton = UIButton().then {
        $0.setImage(.iconRight.withTintColor(.gray4), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    let participantCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 12
            $0.estimatedItemSize = .init(width: Screen.width(68), height: Screen.height(88))
    }).then {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        $0.register(
            ParticipantCollectionViewCell.self,
            forCellWithReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier
        )
    }
    
    private let backgroundView: UIView = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = Screen.height(18)
    }
    
    private let promiseInfoLabel: UILabel = UILabel().then {
        $0.setText("약속 상세 정보", style: .body01, color: .gray7)
    }
    
    private let promiseInfoBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    private let locationInfoLabel: UILabel = UILabel().then {
        $0.setText("위치", style: .caption01, color: .maincolor)
    }
    
    let locationContentLabel: UILabel = UILabel().then {
        $0.setText("sss역 s번 출구", style: .body04, color: .gray7)
    }
    
    private let locationDivideView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let timeInfoLabel: UILabel = UILabel().then {
        $0.setText("약속시간", style: .caption01, color: .maincolor)
    }
    
    let timeContentLabel: UILabel = UILabel().then {
        $0.setText("mm월 dd일 hh:mm", style: .body04, color: .gray7)
    }
    
    private let timeDivideView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let readyLevelInfoLabel: UILabel = UILabel().then {
        $0.setText("준비레벨", style: .caption01, color: .maincolor)
    }
    
    let readyLevelContentLabel: UILabel = UILabel().then {
        $0.setText("LV n. sss", style: .body04, color: .gray7)
    }
    
    private let readyLevelDivideView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let penaltyLevelInfoLabel: UILabel = UILabel().then {
        $0.setText("벌칙", style: .caption01, color: .maincolor)
    }
    
    let penaltyLevelContentLabel: UILabel = UILabel().then {
        $0.setText("ssss하기", style: .body04, color: .gray7)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        addSubviews(
            participantNumberLabel,
            chevronButton,
            participantCollectionView,
            backgroundView,
            promiseInfoLabel,
            promiseInfoBackgroundView
        )
        
        promiseInfoBackgroundView.addSubviews(
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
        participantNumberLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        chevronButton.snp.makeConstraints {
            $0.centerY.equalTo(participantNumberLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(chevronButton.snp.height)
        }
        
        participantCollectionView.snp.makeConstraints {
            $0.top.equalTo(participantNumberLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(88))
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(participantCollectionView.snp.bottom).offset(27)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        promiseInfoLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(26)
            $0.leading.equalToSuperview().offset(20)
        }
        
        promiseInfoBackgroundView.snp.makeConstraints {
            $0.top.equalTo(promiseInfoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        locationInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(12)
        }
        
        locationContentLabel.snp.makeConstraints {
            $0.top.equalTo(locationInfoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(locationInfoLabel)
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
