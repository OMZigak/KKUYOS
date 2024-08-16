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
    
    private let levelView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Screen.height(28) / 2
    }
    
    private let boardHorizontalView = UIImageView().then {
        $0.image = .imgBoardHorizontal
    }
    
    private let boardVerticalView = UIImageView().then {
        $0.image = .imgBoardVertical
    }
    
    let kkumulLabel = UILabel()
    
    let levelCharacterImage = UIImageView()
    
    let levelLabel = UILabel()
    
    let levelCaptionLabel = UILabel()
    
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
            levelView,
            boardVerticalView,
            boardHorizontalView,
            kkumulLabel,
            levelCharacterImage,
            levelLabel,
            levelCaptionLabel,
            promiseView
        )
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
        
        levelView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-38)
            $0.bottom.equalTo(promiseView.snp.top).offset(-20)
            $0.width.equalTo(Screen.width(114))
            $0.height.equalTo(Screen.height(28))
        }
        
        levelLabel.snp.makeConstraints {
            $0.centerX.equalTo(levelView.snp.centerX)
            $0.centerY.equalTo(levelView.snp.centerY)
        }
        
        kkumulLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(106)
        }
        
        levelCharacterImage.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(promiseView.snp.top).offset(-50)
            $0.width.equalTo(Screen.width(160))
            $0.height.equalTo(Screen.height(198))
        }
        
        boardVerticalView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(52)
            $0.bottom.equalTo(promiseView.snp.top)
            $0.width.equalTo(Screen.width(12))
            $0.height.equalTo(Screen.height(140))
        }
        
        boardHorizontalView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalTo(promiseView.snp.top).offset(-80)
            $0.width.equalTo(Screen.width(186))
            $0.height.equalTo(Screen.height(50))
        }
        
        levelCaptionLabel.snp.makeConstraints {
            $0.leading.equalTo(boardHorizontalView).offset(8)
            $0.centerY.equalTo(boardHorizontalView.snp.centerY)
        }
        
        promiseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(630))
            $0.top.equalToSuperview().offset(396)
            $0.bottom.equalTo(contentView)
        }
        
        todayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(16)
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
            $0.top.equalTo(todayPromiseView.snp.bottom).offset(28)
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
