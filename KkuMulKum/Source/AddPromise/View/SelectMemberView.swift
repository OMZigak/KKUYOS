//
//  SelectPeopleView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class SelectMemberView: BaseView {
    private let progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .maincolor
        $0.backgroundColor = .gray2
        $0.setProgress(0.5, animated: false)
    }
    
    private let pageNumberLabel = UILabel().then {
        $0.setText("2/3", style: .body05, color: .gray6)
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("함께 할 꾸물이를\n선택해 보세요", style: .head01, color: .gray8)
    }
    
    private let descriptionStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    let memberListView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: Screen.width(104), height: Screen.height(128))
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
        }
    ).then {
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = false
        $0.register(
            SelectMemberCell.self,
            forCellWithReuseIdentifier: SelectMemberCell.reuseIdentifier
        )
    }
    
    let confirmButton = CustomButton(title: "다음")
    
    override func setupView() {
        descriptionStackView.addArrangedSubviews(pageNumberLabel, titleLabel)
        addSubviews(
            progressView,
            descriptionStackView,
            memberListView,
            confirmButton
        )
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(-2)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(3))
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        memberListView.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-167)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(CustomButton.defaultHeight))
            $0.bottom.equalToSuperview().offset(-64)
        }
    }
}
