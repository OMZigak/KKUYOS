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
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
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
        
        setupPopUpViewController(viewController: inviteCodePopUpViewController)
        setupPopUpAction(view: inviteCodePopUpViewController.rootView)
        removeDismissGesture(view: inviteCodePopUpViewController.rootView)
        createMeetingViewModel.createMeeting(name: createMeetingViewModel.meetingName.value)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            inviteCodePopUpViewController.rootView.setInvitationCodeText(
                self.createMeetingViewModel.inviteCode.value
            )
            
            self.present(inviteCodePopUpViewController, animated: true)
        }
    }
    
    @objc
    private func copyButtonDidTapped() {
        UIPasteboard.general.string = createMeetingViewModel.inviteCode.value
        
        let finishCreateViewController = FinishCreateViewController(meetingID: createMeetingViewModel.meetingID)
        
        navigationController?.pushViewController(finishCreateViewController, animated: true)
    }
    
    @objc
    private func inviteLaterButtonDidTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let finishCreateViewController = FinishCreateViewController(meetingID: self.createMeetingViewModel.meetingID)
            
            self.navigationController?.pushViewController(finishCreateViewController, animated: true)
        }
    }
    
    private func setupPopUpViewController(viewController: BaseViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        viewController.view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private func setupPopUpAction(view: InvitationCodePopUpView) {
        view.copyButton.addTarget(
            self,
            action: #selector(copyButtonDidTapped),
            for: .touchUpInside
        )
        
        view.inviteLaterButton.addTarget(
            self,
            action: #selector(inviteLaterButtonDidTapped),
            for: .touchUpInside
        )
    }
    
    private func removeDismissGesture(view: BaseView) {
        if let gesture = view.gestureRecognizers?.first {
            view.removeGestureRecognizer(gesture)
        }
    }
}
