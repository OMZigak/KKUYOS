//
//  CreateMeetingViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateMeetingViewController: BaseViewController {
    private let createMeetingViewModel: CreateMeetingViewModel = CreateMeetingViewModel(service: CreateMeetingService())
    
    private let createMeetingView: CreateMeetingView = CreateMeetingView()
    
    override func loadView() {
        view = createMeetingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupTapGesture()
    }
    
    override func setupView() {
        setupNavigationBar(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
    
    private func setupBinding() {
        createMeetingViewModel.inviteCodeState.bind(with: self) { owner, state in
            switch state {
            case .empty, .invalid:
                self.createMeetingView.presentButton.isEnabled = false
            case .valid:
                self.createMeetingView.presentButton.isEnabled = true
            }
            
            self.createMeetingViewModel.characterCount.bind(with: self) { owner, count in
                self.createMeetingView.characterLabel.text = count
            }
        }
    }
    
    override func setupAction() {
        createMeetingView.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        createMeetingView.presentButton.addTarget(self, action: #selector(presentButtonDidTapped), for: .touchUpInside)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        createMeetingViewModel.validateName(textField.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        createMeetingView.nameTextField.layer.borderColor = UIColor.gray3.cgColor
    }
    
    @objc private func presentButtonDidTapped() {
        // TODO: 서버 연결해서 초대 코드 받아올 수 있게 처리
        let inviteCodePopUpViewController = InvitationCodePopUpViewController(invitationCode: createMeetingViewModel.inviteCode.value)
        
        inviteCodePopUpViewController.modalPresentationStyle = .overFullScreen
        inviteCodePopUpViewController.modalTransitionStyle = .crossDissolve
        inviteCodePopUpViewController.view.backgroundColor = .black.withAlphaComponent(0.7)
        
        present(inviteCodePopUpViewController, animated: true, completion: nil)
    }
}
