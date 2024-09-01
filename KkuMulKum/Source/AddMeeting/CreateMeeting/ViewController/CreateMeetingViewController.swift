//
//  CreateMeetingViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateMeetingViewController: BaseViewController {
    
    
    // MARK: Property

    private let viewModel: CreateMeetingViewModel
    private let rootView: CreateMeetingView = CreateMeetingView()
    
    
    // MARK: - LifeCycle
    
    init(viewModel: CreateMeetingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - Setup

    override func setupView() {
        setupNavigationBarTitle(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
    
    override func setupAction() {
        rootView.nameTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        rootView.presentButton.addTarget(
            self,
            action: #selector(presentButtonDidTap),
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
        viewModel.inviteCodeState.bind(with: self) { owner, state in
            owner.rootView.presentButton.isEnabled = false
            owner.rootView.errorLabel.isHidden = true
            
            switch state {
            case .valid:
                owner.rootView.presentButton.isEnabled = true
            case .invalid:
                owner.rootView.errorLabel.isHidden = false
            case .empty:
                break
            }
        }
        
        viewModel.characterCount.bind(with: self) { owner, count in
            owner.rootView.characterLabel.text = "\(count)/10"
        }
        
        viewModel.meetingName.bind(with: self) { owner, name in
            owner.viewModel.validateName()
        }
    }
    
    @objc 
    func textFieldDidChange(_ textField: UITextField) {
        viewModel.meetingName.value = textField.text ?? ""
        viewModel.characterCount.value = "\(textField.text?.count ?? 0)"
    }
    
    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
        rootView.nameTextField.layer.borderColor = UIColor.gray3.cgColor
    }
    
    @objc 
    func presentButtonDidTap() {
        let inviteCodePopUpViewController = InvitationCodePopUpViewController(
            invitationCode: viewModel.inviteCode.value
        )
        
        setupPopUpViewController(viewController: inviteCodePopUpViewController)
        setupPopUpAction(view: inviteCodePopUpViewController.rootView)
        removeDismissGesture(view: inviteCodePopUpViewController.rootView)
        viewModel.createMeeting(name: viewModel.meetingName.value)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            inviteCodePopUpViewController.rootView.setInvitationCodeText(self.viewModel.inviteCode.value)
            
            self.present(inviteCodePopUpViewController, animated: true)
        }
    }
    
    @objc
    private func copyButtonDidTap() {
        UIPasteboard.general.string = viewModel.inviteCode.value
        
        let finishCreateViewController = CreateSuccessViewController(meetingID: viewModel.meetingID)
        
        navigationController?.pushViewController(finishCreateViewController, animated: true)
    }
    
    @objc
    private func inviteLaterButtonDidTap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let finishCreateViewController = CreateSuccessViewController(meetingID: self.viewModel.meetingID)
            
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
            action: #selector(copyButtonDidTap),
            for: .touchUpInside
        )
        
        view.inviteLaterButton.addTarget(
            self,
            action: #selector(inviteLaterButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func removeDismissGesture(view: BaseView) {
        if let gesture = view.gestureRecognizers?.first {
            view.removeGestureRecognizer(gesture)
        }
    }
}
