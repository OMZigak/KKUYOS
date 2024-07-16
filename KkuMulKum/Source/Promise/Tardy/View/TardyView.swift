//
//  TardyView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import UIKit

class TardyView: BaseView {
    
    
    // MARK: Property

    private let tardyPenaltyView: TardyPenaltyView = TardyPenaltyView().then {
        $0.layer.cornerRadius = 8
    }
    
    private let titleLabel: UILabel = UILabel().then {
        $0.setText("이번 약속의 지각 꾸물이는?", style: .head01, color: .gray8)
    }
    
    private let tardyEmptyView: TardyEmptyView = TardyEmptyView()
    
    let tardyCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: Screen.width(104), height: Screen.height(128))
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
        }
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(
            TardyCollectionViewCell.self,
            forCellWithReuseIdentifier: TardyCollectionViewCell.reuseIdentifier
        )
    }
    
    let finishMeetingButton: CustomButton = CustomButton(
        title: "약속 마치기",
        isEnabled: false
    ).then {
        $0.backgroundColor = .maincolor
    }
    
    
    // MARK: - Setup

    override func setupView() {
        backgroundColor = .white
        
        addSubviews(
            tardyPenaltyView,
            titleLabel,
            tardyEmptyView,
            tardyCollectionView,
            finishMeetingButton
        )
    }
    
    override func setupAutoLayout() {
        tardyPenaltyView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(19)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(74))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tardyPenaltyView.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
        }
        
        tardyEmptyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(108)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(192))
            $0.width.equalTo(Screen.width(112))
        }
        
        finishMeetingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.width.equalTo(CustomButton.defaultWidth)
        }
        
        tardyCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.bottom.equalTo(finishMeetingButton.snp.top).inset(-15)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
