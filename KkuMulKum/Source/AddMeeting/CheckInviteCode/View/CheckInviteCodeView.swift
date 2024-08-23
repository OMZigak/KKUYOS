//
//  CheckInviteCodeView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class CheckInviteCodeView: BaseView {
    
    
    // MARK: Property
    
    let enterInviteCodeView: JoinButtonView = JoinButtonView(
        mainTitle: "초대 코드 입력하기",
        subTitle: "초대 코드를 받았다면"
    ).then {
        $0.layer.cornerRadius = 8
    }
    
    let createMeetingView: JoinButtonView = JoinButtonView(
        mainTitle: "직접 모임 추가하기",
        subTitle: "초대 코드가 없다면"
    ).then {
        $0.layer.cornerRadius = 8
    }

    private let checkInviteLabel: UILabel = UILabel().then {
        $0.setText("친구에게 받은\n모임 초대 코드가 있으신가요?", style: .head01, color: .gray8)
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        self.addSubviews(
            checkInviteLabel,
            enterInviteCodeView,
            createMeetingView
        )
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        checkInviteLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        enterInviteCodeView.snp.makeConstraints {
            $0.top.equalTo(checkInviteLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        createMeetingView.snp.makeConstraints {
            $0.top.equalTo(enterInviteCodeView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
