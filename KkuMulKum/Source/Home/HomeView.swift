//
//  HomeView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/9/24.
//

import UIKit

import Then
import SnapKit


// MARK: - HomeView

final class HomeView: BaseView {
    
    
    // MARK: - Property
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .gray0
        $0.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .maincolor
    }
    
    private let logo = UIImageView().then {
        $0.image = .imgLogo
    }
    
    private let kkumulLabel = UILabel().then {
        $0.setText("꾸물리안 님,\n14번의 약속에서\n10번 꾸물거렸어요!", style: .title02, color: .white)
        $0.setHighlightText("꾸물리안 님,", style: .title00, color: .white)
        $0.setHighlightText("14번", "10번", style: .title00, color: .lightGreen)
    }
    
    private let levelView = UIStackView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let levelLabel = UILabel().then {
        $0.setText("Lv.0 새끼 꾸물이", style: .caption01, color: .gray6)
        $0.setHighlightText("Lv.0", style: .caption01, color: .maincolor)
    }
    
    private let levelCaptionView = UIImageView().then {
        $0.image = .imgBoard
    }
    
    private let levelCaptionLabel = UILabel().then {
        $0.setText(
            "아직 한번도 정시에 도착하지 못했어요!\n정시 도착으로 캐릭터를 성장시켜 보세요",
            style: .label02,
            color: .gray7
        )
    }
    
    private let promiseView = UIView().then {
        $0.backgroundColor = .gray0
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    private let todayLabel = UILabel().then {
        $0.setText("오늘의 약속은?", style: .body01, color: .gray8)
    }
    
    private let todayButton = UIButton().then {
        let icon = UIImage(resource: .iconRight)
        $0.setImage(icon, for: .normal)
    }
    
    private let todayPromiseView = TodayPromiseView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    private let upcomingLabel = UILabel().then {
        $0.setText("다가올 나의 약속은?", style: .body01, color: .gray8)
    }
    
    lazy var upcomingPromiseView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.isPagingEnabled = true
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            logo,
            kkumulLabel,
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
            upcomingLabel,
            upcomingPromiseView
        )
    }
    
    override func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(58)
            $0.width.equalTo(64)
            $0.height.equalTo(24)
        }
        
        kkumulLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(110)
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
            $0.width.equalTo(186)
            $0.height.equalTo(150)
        }
        
        levelCaptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(278)
        }
        
        promiseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(646)
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
            $0.height.equalTo(254)
        }
        
        upcomingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(342)
        }
        
        upcomingPromiseView.snp.makeConstraints {
            $0.top.equalTo(upcomingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(216)
        }
    }
}
