//
//  JoinButtonView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class JoinButtonView: BaseView {
    
    
    // MARK: Property

    private let subTitleLabel: UILabel = UILabel().then {
        $0.setText("subTitleLabel", style: .caption02, color: .gray5)
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("mainTitleLabel", style: .body03, color: .gray8)
    }
    
    private let chevronImageView: UIImageView = UIImageView().then {
        $0.image = .iconRight.withTintColor(.gray3)
        $0.contentMode = .scaleAspectFit
    }
    
    
    // MARK: - Setup

    override func setupView() {
        self.backgroundColor = .green1
        
        self.addSubviews(
            subTitleLabel,
            mainTitleLabel,
            chevronImageView
        )
    }
    
    override func setupAutoLayout() {
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(8)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(chevronImageView.snp.height)
        }
    }
}


// MARK: - Extension

extension JoinButtonView {
    func setJoinButtonViewStatus(isReceived: Bool) {
        subTitleLabel.setText(
            isReceived ? "초대 코드를 받았다면" : "초대 코드가 없다면",
            style: .caption02,
            color: .gray5
        )
        
        mainTitleLabel.setText(
            isReceived ? "초대 코드 입력하기" : "직접 모임 추가하기",
            style: .body03,
            color: .gray8
        )
    }
}
