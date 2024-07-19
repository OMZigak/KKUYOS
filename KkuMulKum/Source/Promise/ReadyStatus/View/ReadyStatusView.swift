//
//  ReadyStatusView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class ReadyStatusView: BaseView {
    private let scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView: UIView = UIView()
    
    private let baseStackView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 24
        $0.backgroundColor = .gray0
    }
    
    let enterReadyButtonView: EnterReadyInfoButtonView = EnterReadyInfoButtonView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let readyPlanInfoView: ReadyPlanInfoView = ReadyPlanInfoView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let myReadyStatusTitleLabel: UILabel = UILabel().then {
        $0.setText("나의 준비 현황", style: .body01, color: .gray8)
    }
    
    private let readyBaseView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 4
    }
    
    let myReadyStatusProgressView: ReadyStatusProgressView = ReadyStatusProgressView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let popUpImageView: UIImageView = UIImageView(image: .imgTextPopup).then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let ourReadyStatusLabel: UILabel = UILabel().then {
        $0.setText(
            "우리들의 준비 현황",
            style: .body01,
            color: .gray8
        )
    }
    
    let ourReadyStatusCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.estimatedItemSize = .init(width: Screen.width(335), height: Screen.height(72))
        }).then {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.register(
                OurReadyStatusCollectionViewCell.self,
                forCellWithReuseIdentifier: OurReadyStatusCollectionViewCell.reuseIdentifier
            )
        }
    
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
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        baseStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        ourReadyStatusCollectionView.snp.makeConstraints {
            $0.top.equalTo(baseStackView.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
