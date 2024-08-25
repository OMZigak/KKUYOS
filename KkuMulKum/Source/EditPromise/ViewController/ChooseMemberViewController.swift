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

private extension ChooseMemberViewController {
    @objc
    func confirmButtonDidTap() {
        let viewController = EnterContentViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
