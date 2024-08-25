//
//  EnterContentViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import UIKit

class EnterContentViewController: BaseViewController {
    let viewModel: EditPromiseViewModel
    
    private let rootView: SelectPenaltyView = SelectPenaltyView()
    
    
    // MARK: - LifeCycle
    
    init(viewModel: EditPromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "약속 수정하기")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        rootView.confirmButton.isEnabled = true
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
}


// MARK: - Extension

private extension EnterContentViewController {
    @objc
    func confirmButtonDidTap() {
        // TODO: 약속 수정 API 연결
        let viewController = AddPromiseCompleteViewController(promiseID: viewModel.promiseID)
        
        viewController.setupNavigationBarTitle(with: "약속 수정하기")
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
