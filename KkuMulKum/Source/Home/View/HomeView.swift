//
//  HomeView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/9/24.
//

import UIKit

import Then
import SnapKit

final class HomeView: BaseView {
    
    
    // MARK: - Property
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private let safeAreaView = UIView(backgroundColor: .maincolor)
    
    private let contentView = UIView(backgroundColor: .maincolor)
    
    private let logo = UIImageView().then {
        $0.image = .imgLogo
    }
    
    let kkumulLabel = UILabel()
    
    let levelCharacterImage = UIImageView()
    
    let levelLabel = UILabel()
    
    let levelCaptionLabel = UILabel()
    
    private let levelView = UIStackView(axis: .horizontal).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let levelCaptionView = UIImageView().then {
        $0.image = .imgBoard
    }
    
    private let promiseView = UIView(backgroundColor: .gray0).then {
        $0.roundCorners(
            cornerRadius: 16,
            maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        )
    }
    
    private let todayLabel = UILabel().then {
        $0.setText("오늘의 약속은?", style: .body01, color: .gray8)
    }
    
    private let upcomingLabel = UILabel().then {
        $0.setText("다가올 나의 약속은?", style: .body01, color: .gray8)
    }
    
    let todayButton = UIButton().then {
        let icon = UIImage(resource: .iconRight)
        $0.setImage(icon, for: .normal)
    }
    
    let todayEmptyView = TodayEmptyView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.isHidden = true
    }
    
    let upcomingEmptyView = UpcomingEmptyView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.isHidden = true
    }
    
    let todayPromiseView = TodayPromiseView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    lazy var upcomingPromiseView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.isPagingEnabled = true
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubviews(scrollView, safeAreaView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            logo,
            kkumulLabel,
            levelCharacterImage,
            levelView,
            levelCaptionView,
            levelCaptionLabel,
            promiseView
        )
        levelView.addSubview(levelLabel)
        promiseView.addSubviews(
            todayLabel,
            todayButton,
            todayPromiseView,
            todayEmptyView,
            upcomingLabel,
            upcomingPromiseView,
            upcomingEmptyView
        )
    }
    
    override func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        safeAreaView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(60)
            $0.width.equalTo(64)
            $0.height.equalTo(24)
        }
        
        kkumulLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(112)
        }
        
        levelCharacterImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(106)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(198)
        }
        
        levelView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-36)
            $0.top.equalToSuperview().offset(350)
        }
        
        levelLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.bottom.equalToSuperview().inset(6)
        }
        
        levelCaptionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(258)
            $0.width.equalTo(Screen.width(186))
            $0.height.equalTo(Screen.height(150))
        }
        
        levelCaptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(278)
        }
        
        promiseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(630))
            $0.top.equalToSuperview().offset(396)
            $0.bottom.equalTo(contentView)
        }
        
        todayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        todayButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(todayLabel.snp.centerY)
            $0.size.equalTo(20)
        }
        
        todayPromiseView.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(254))
        }
        
        todayEmptyView.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(254))
        }
        
        upcomingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(todayPromiseView.snp.bottom).offset(32)
        }
        
        upcomingPromiseView.snp.makeConstraints {
            $0.top.equalTo(upcomingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(216))
        }
        
        upcomingEmptyView.snp.makeConstraints {
            $0.top.equalTo(upcomingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(140)
        }
    }
}
