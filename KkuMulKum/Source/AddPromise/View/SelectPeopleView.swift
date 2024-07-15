//
//  SelectPeopleView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class SelectPeopleView: BaseView {
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
    
    let peopleListView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
        }
    )
    
    override func setupView() {
        descriptionStackView.addArrangedSubviews(pageNumberLabel, titleLabel)
        addSubviews(
            progressView,
            descriptionStackView
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
    }
}
