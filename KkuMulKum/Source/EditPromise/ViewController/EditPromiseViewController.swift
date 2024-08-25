//
//  EditPromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import UIKit

class EditPromiseViewController: BaseViewController {
    private let rootView: AddPromiseView = AddPromiseView()
    
    
    // MARK: - LifeCycle

    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    
    // MARK: - Setup

    override func setupView() {
        rootView.titleLabel.text = "약속을\n수정해 주세요"
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
}


// MARK: - Extension

private extension EditPromiseViewController {
    @objc
    func confirmButtonDidTap() {
        // TODO: 꾸물이 선택 뷰 연결
    }
}
