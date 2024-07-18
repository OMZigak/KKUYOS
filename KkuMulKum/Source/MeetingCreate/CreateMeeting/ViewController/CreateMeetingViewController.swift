//
//  CreateMeetingViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateMeetingViewController: BaseViewController {
    
    
    // MARK: Property

    private let createMeetingViewModel: CreateMeetingViewModel
    
    private let createMeetingView: CreateMeetingView = CreateMeetingView()
    
    
    // MARK: Initialize
    
    init(viewModel: CreateMeetingViewModel) {
        self.createMeetingViewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    override func loadView() {
        view = createMeetingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupTapGesture()
    }
    
    
    // MARK: - Setup

    override func setupView() {
        setupNavigationBarTitle(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
    
    override func setupAction() {
        createMeetingView.nameTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        createMeetingView.presentButton.addTarget(
            self,
            action: #selector(presentButtonDidTapped),
            for: .touchUpInside
        )
    }
}


// MARK: - Extension

private extension CreateMeetingViewController {
    func setupBinding() {
        createMeetingViewModel.inviteCodeState.bind(with: self) { owner, state in
            switch state {
            case .empty, .invalid:
                owner.createMeetingView.presentButton.isEnabled = false
            case .valid:
                owner.createMeetingView.presentButton.isEnabled = true
            }
            
            owner.createMeetingViewModel.characterCount.bind(with: self) { owner, count in
                owner.createMeetingView.characterLabel.text = count
            }
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc 
    func textFieldDidChange(_ textField: UITextField) {
        createMeetingViewModel.validateName(textField.text ?? "")
    }
    
    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
        createMeetingView.nameTextField.layer.borderColor = UIColor.gray3.cgColor
    }
    
    @objc 
    func presentButtonDidTapped() {
        let inviteCodePopUpViewController = InvitationCodePopUpViewController(
            invitationCode: createMeetingViewModel.inviteCode.value
        )
        
        inviteCodePopUpViewController.modalPresentationStyle = .overFullScreen
        inviteCodePopUpViewController.modalTransitionStyle = .crossDissolve
        inviteCodePopUpViewController.view.backgroundColor = .black.withAlphaComponent(0.7)
        
        inviteCodePopUpViewController.rootView.copyButton.addTarget(
            self,
            action: #selector(self.copyButtonDidTapped),
            for: .touchUpInside
        )
        inviteCodePopUpViewController.rootView.inviteLaterButton.addTarget(
            self,
            action: #selector(self.inviteLaterButtonDidTapped),
            for: .touchUpInside
        )
        
        createMeetingViewModel.createMeeting(
            name: createMeetingViewModel.meetingName.value
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            inviteCodePopUpViewController.rootView.setInvitationCodeText(
                self.createMeetingViewModel.inviteCode.value
            )
            
            self.present(inviteCodePopUpViewController, animated: true, completion: nil)
        }
    }
    
    @objc
    private func copyButtonDidTapped() {
        let finishCreateViewController = FinishCreateViewController()
        
        navigationController?.pushViewController(finishCreateViewController, animated: true)
    }
    
    @objc
    private func inviteLaterButtonDidTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let finishCreateViewController = FinishCreateViewController()
            
            self.navigationController?.pushViewController(finishCreateViewController, animated: true)
        }
    }
}
