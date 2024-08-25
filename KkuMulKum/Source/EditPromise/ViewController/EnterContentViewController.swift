//
//  EnterContentViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import UIKit

class EnterContentViewController: BaseViewController {
    private let rootView: SelectPenaltyView = SelectPenaltyView()
    
    
    // MARK: - LifeCycle

    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "약속 수정하기")
    }
    
    
    // MARK: - Setup
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
}


// MARK: - Extension

private extension EnterContentViewController {
    @objc
    func confirmButtonDidTap() {
        // TODO: 약속 수정 축하 뷰 연결 및 API 연결
    }
}
