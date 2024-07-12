//
//  CreateGroupViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateGroupViewController: BaseViewController {
    private let createGroupView: CreateGroupView = CreateGroupView()
    
    override func loadView() {
        view = createGroupView
    }
    
    override func setupView() {
        setupNavigationBarTitle(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
}
