//
//  ArriveView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import UIKit

class ArriveView: BaseView {
    
    
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
    
    let finishMeetingButton: CustomButton = CustomButton(
        title: "약속 마치기",
        isEnabled: true
    ).then {
        $0.backgroundColor = .maincolor
    }
    
    
    // MARK: - Setup

    override func setupView() {
        backgroundColor = .green1
        
        addSubviews(
            giftImageView,
            mainTitleLabel,
            subTitleLabel,
            finishMeetingButton
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
            $0.top.equalTo(giftImageView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
        
        finishMeetingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.width.equalTo(CustomButton.defaultWidth)
        }
    }
}
