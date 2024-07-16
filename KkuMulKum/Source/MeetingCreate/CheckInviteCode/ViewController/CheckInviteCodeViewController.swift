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

    override func loadView() {
        view = checkInviteCodeView
    }
    
    
    // MARK: Setup
    
    override func setupView() {
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        
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
                service: MockInviteCodeService()
            )
        )
        
        inviteCodeViewController.modalTransitionStyle = .crossDissolve
        inviteCodeViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(inviteCodeViewController, animated: true)
    }
    
    @objc 
    private func createMeetingViewDidTap() {
        let createMeetingViewController = CreateMeetingViewController(
            viewModel: CreateMeetingViewModel(
                createMeetingService: MockCreateMeetingService()
            )
        )
        
        createMeetingViewController.modalTransitionStyle = .crossDissolve
        createMeetingViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(createMeetingViewController, animated: true)
    }
}
