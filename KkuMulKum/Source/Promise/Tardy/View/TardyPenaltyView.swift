//
//  TardyPenaltyView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import UIKit

class TardyPenaltyView: BaseView {
    private let penaltyImageView: UIImageView = UIImageView().then {
        $0.image = .iconPenalty
        $0.contentMode = .scaleAspectFit
    }
    
    private let penaltyLabel: UILabel = UILabel().then {
        $0.setText("벌칙", style: .caption02, color: .gray8)
    }
    
    private let contentLabel: UILabel = UILabel().then {
        $0.setText("탕후루 릴스 찍기", style: .body03, color: .gray8)
    }
    
    override func setupView() {
        backgroundColor = .green1
        
        addSubviews(
            penaltyImageView,
            penaltyLabel,
            contentLabel
        )
    }
    
    override func setupAutoLayout() {
        penaltyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(penaltyImageView.snp.height)
        }
        
        penaltyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(penaltyImageView.snp.trailing).offset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.leading.equalTo(penaltyLabel)
        }
    }
}
