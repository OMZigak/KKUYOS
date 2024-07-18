//
//  CheckInviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class CheckInviteCodeViewController: BaseViewController {
    
    
    // MARK: Property

    private let checkInviteCodeView: CheckInviteCodeView = CheckInviteCodeView()
    
    
    // MARK: LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    override func loadView() {
        view = checkInviteCodeView
    }
    
    
    // MARK: Setup
    
    override func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBarTitle(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
    
    override func setupAction() {
        checkInviteCodeView.enterInviteCodeView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(inviteCodeViewDidTap)
        ))
        checkInviteCodeView.createMeetingView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(createMeetingViewDidTap)
        ))
    }
}


// MARK: Extension

private extension CheckInviteCodeViewController {
    @objc 
    func inviteCodeViewDidTap() {
        let inviteCodeViewController = InviteCodeViewController(
            viewModel: InviteCodeViewModel(
                service: MeetingService()
            )
        )
        
        navigationController?.pushViewController(inviteCodeViewController, animated: true)
    }
    
    @objc 
    private func createMeetingViewDidTap() {
        let createMeetingViewController = CreateMeetingViewController(
            viewModel: CreateMeetingViewModel(
                createMeetingService: MeetingService()
            )
        )
        
        navigationController?.pushViewController(createMeetingViewController, animated: true)
    }
}
