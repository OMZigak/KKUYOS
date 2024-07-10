//
//  CheckInviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class CheckInviteCodeViewController: BaseViewController {
    private let checkInviteCodeView: CheckInviteCodeView = CheckInviteCodeView()
    
    override func setupView() {
        view.backgroundColor = .white
        self.navigationItem.title = "내 모임 추가하기"
        self.tabBarController?.tabBar.isHidden = true
        
        view.addSubview(checkInviteCodeView)
        
        checkInviteCodeView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
