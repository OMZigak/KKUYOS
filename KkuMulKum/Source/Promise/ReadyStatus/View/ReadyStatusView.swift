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
        $0.setText("우리들의 준비 현황", style: .body01, color: .gray8)
    }
    
    private let ourReadyStatusBackView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Screen.height(18)
    }
    
    private let bottomBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .white
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
            myReadyStatusTitleLabel
        )
        
        contentView.addSubviews(
            baseStackView,
            readyBaseView,
            ourReadyStatusBackView,
            ourReadyStatusLabel,
            ourReadyStatusCollectionView
        )
        
        scrollView.addSubview(contentView)
        
        addSubviews(scrollView, bottomBackgroundView)
        
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
        
        readyBaseView.snp.makeConstraints {
            $0.top.equalTo(baseStackView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        ourReadyStatusBackView.snp.makeConstraints {
            $0.top.equalTo(readyBaseView.snp.bottom).offset(24)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        ourReadyStatusLabel.snp.makeConstraints {
            $0.top.equalTo(readyBaseView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        
        ourReadyStatusCollectionView.snp.makeConstraints {
            $0.top.equalTo(ourReadyStatusLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            self.collectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(ourReadyStatusCollectionView.snp.bottom).offset(20)
        }
        
        ourReadyStatusBackView.snp.makeConstraints {
            $0.top.equalTo(readyBaseView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bottomBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(600))
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
