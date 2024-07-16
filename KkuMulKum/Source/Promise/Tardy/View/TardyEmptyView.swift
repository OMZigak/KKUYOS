//
//  TardyEmptyView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import UIKit

class TardyEmptyView: BaseView {
    
    
    // MARK: Property

    private let characterImageView: UIImageView = UIImageView().then {
        $0.image = .imgEmptyTardy
        $0.contentMode = .scaleAspectFit
    }
    
    private let emptyContentLabel: UILabel = UILabel().then {
        $0.setText("꾸물이들이 도착하길\n기다리는 중이에요", style: .body05, color: .gray3)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        addSubviews(characterImageView, emptyContentLabel)
    }
    
    override func setupAutoLayout() {
        characterImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(121))
            $0.width.equalTo(Screen.width(112))
        }
        
        emptyContentLabel.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(36)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
