//
//  TodayEmptyView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class TodayEmptyView: BaseView {
    
    
    // MARK: - Property
    
    private let emptyCharacter = UIImageView().then {
        $0.image = .imgEmptyCharacter
    }
    
    private let emptyLabel = UILabel().then {
        $0.setText("꾸물꾸물...\n오늘 약속은 없네요!", style: .body05, color: .gray3)
        $0.textAlignment = .center
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubviews(emptyCharacter, emptyLabel)
    }
    
    override func setupAutoLayout() {
        emptyCharacter.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(73)
            $0.height.equalTo(126)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyCharacter.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
