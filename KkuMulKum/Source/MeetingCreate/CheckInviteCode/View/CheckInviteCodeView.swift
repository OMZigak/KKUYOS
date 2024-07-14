//
//  CheckInviteCodeView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class CheckInviteCodeView: BaseView {
    private let checkInviteLabel: UILabel = UILabel().then {
        $0.setText("친구에게 받은\n모임 초대 코드가 있으신가요?", style: .head01, color: .gray8)
    }
    
    let enterInviteCodeView: JoinButtonView = JoinButtonView().then {
        $0.setJoinButtonViewStatus(isReceived: true)
    }
    
    let createMeetingView: JoinButtonView = JoinButtonView().then {
        $0.setJoinButtonViewStatus(isReceived: false)
    }
    
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
