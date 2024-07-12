//
//  EnterInviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class EnterInviteCodeViewController: BaseViewController {
    private let enterInviteCodeView: EnterInviteCodeView = EnterInviteCodeView()
    
    override func loadView() {
        view = enterInviteCodeView
    }
    
    override func setupView() {
        setupNavigationBarTitle(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
}
