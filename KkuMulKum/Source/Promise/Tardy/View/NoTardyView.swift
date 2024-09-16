//
//  NoTardyView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import UIKit

class NoTardyView: BaseView {
    
    
    // MARK: Property
    
    private let giftImageView: UIImageView = UIImageView().then {
        $0.image = .imgGift
        $0.contentMode = .scaleAspectFit
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("축하해요!", style: .head01, color: .gray8)
    }
    
    private let subTitleLabel: UILabel = UILabel().then {
        $0.setText("약속 시간까지 아무도 꾸물거리지 않았네요!", style: .body06, color: .gray6)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        backgroundColor = .green1
        
        addSubviews(
            giftImageView,
            mainTitleLabel,
            subTitleLabel
        )
    }
    
    override func setupAutoLayout() {
        giftImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(131)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(177))
            $0.width.equalTo(Screen.width(187))
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(giftImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}
