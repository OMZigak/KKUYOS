//
//  ChooseMemberViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import UIKit

class ChooseMemberViewController: BaseViewController {
    private let rootView: SelectMemberView = SelectMemberView()
    
    
    // MARK: - LifeCycle

    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    
    // MARK: - Setup
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
}


// MARK: - Extension

private extension ChooseMemberViewController {
    @objc
    func confirmButtonDidTap() {
        // TODO: 약속 내용 입력 뷰 연결
    }
}
