//
//  ReadyStatusView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

import SnapKit

class ReadyStatusView: BaseView {
    
    
    // MARK: Property
    
    let enterReadyButtonView: EnterReadyInfoButtonView = EnterReadyInfoButtonView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let readyPlanInfoView: ReadyPlanInfoView = ReadyPlanInfoView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let myReadyStatusProgressView: ReadyStatusProgressView = ReadyStatusProgressView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let popUpImageView: UIImageView = UIImageView(image: .imgTextPopup).then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    let ourReadyStatusCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.estimatedItemSize = .init(width: Screen.width(335), height: Screen.height(72))
            $0.minimumInteritemSpacing = 10
        }).then {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.register(
                OurReadyStatusCollectionViewCell.self,
                forCellWithReuseIdentifier: OurReadyStatusCollectionViewCell.reuseIdentifier
            )
        }
    
    private let scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView: UIView = UIView()
    
    private let baseStackView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 24
        $0.backgroundColor = .gray0
    }
    
    private let myReadyStatusTitleLabel: UILabel = UILabel().then {
        $0.setText("나의 준비 현황", style: .body01, color: .gray8)
    }
    
    private let readyBaseView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 4
    }
    
    private let ourReadyStatusLabel: UILabel = UILabel().then {
        $0.setText(
            "우리들의 준비 현황",
            style: .body01,
            color: .gray8
        )
    }
    
    private var collectionViewHeightConstraint: Constraint?
    
    
    // MARK: - Setup
    
    override func setupView() {
        readyBaseView.addArrangedSubviews(
            myReadyStatusProgressView,
            popUpImageView
        )
        
        baseStackView.addArrangedSubviews(
            enterReadyButtonView,
            readyPlanInfoView,
            myReadyStatusTitleLabel,
            readyBaseView,
            ourReadyStatusLabel
        )
        
        contentView.addSubviews(
            baseStackView,
            ourReadyStatusCollectionView
        )
        
        scrollView.addSubview(contentView)
        
        addSubviews(scrollView)
        
    }
    
    override func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        baseStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        ourReadyStatusCollectionView.snp.makeConstraints {
            $0.top.equalTo(baseStackView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(20)
            self.collectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(ourReadyStatusCollectionView.snp.bottom).offset(20)
        }
    }
}


// MARK: - Extension

extension ReadyStatusView {
    func updateCollectionViewHeight() {
        ourReadyStatusCollectionView.layoutIfNeeded()
        let contentHeight = ourReadyStatusCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: contentHeight)
        layoutIfNeeded()
    }
}
