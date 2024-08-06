//
//  SetReadyInfoCompletedViewController.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/17/24.
//

import UIKit

final class SetReadyCompletedViewController: BaseViewController {
    
    private let rootView = SetReadyCompletedView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green1
        
        setupNavigationBarTitle(with: "준비 정보 입력하기")
        navigationItem.hidesBackButton = true
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
}

private extension SetReadyCompletedViewController {
    @objc
    func confirmButtonDidTap() {
        guard let viewControllers = navigationController?.viewControllers else { return }
        for viewController in viewControllers {
            if let pagePromiseViewController = viewController as? PromiseViewController {
                navigationController?.popToViewController(pagePromiseViewController, animated: true)
                break
            }
        }
    }
}
