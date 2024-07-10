//
//  JoinButtonView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class JoinButtonView: BaseView {
    private let subTitleLabel: UILabel = UILabel().then {
        $0.setText("초대 코드를 받았다면", style: .caption02)
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("초대 코드 입력하기", style: .body03)
    }
    
    private let chevronImageView: UIImageView = UIImageView().then {
        $0.image = .iconRight
        $0.contentMode = .scaleAspectFit
    }
    
    override func setupView() {
        self.backgroundColor = .green1
        
        self.addSubviews(subTitleLabel, mainTitleLabel, chevronImageView)
    }
    
    override func setupAutoLayout() {
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.top.equalTo(subTitleLabel).offset(14)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(chevronImageView.snp.height)
        }
    }
}
