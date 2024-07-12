//
//  CreateGroupViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateGroupViewController: BaseViewController {
    private let createGroupViewModel: CreateGroupViewModel = CreateGroupViewModel(service: CreateGroupService())
    
    private let createGroupView: CreateGroupView = CreateGroupView()
    
    override func loadView() {
        view = createGroupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupTapGesture()
    }
    
    override func setupView() {
        setupNavigationBarTitle(with: "내 모임 추가하기")
        setupNavigationBarBackButton()
    }
    
    private func setupBinding() {
        createGroupViewModel.inviteCodeState.bind(with: self) { owner, state in
            switch state {
            case .empty, .invalid:
                self.createGroupView.presentButton.isEnabled = false
            case .valid:
                self.createGroupView.presentButton.isEnabled = true
            }
            
            self.createGroupViewModel.characterCount.bind(with: self) { owner, count in
                self.createGroupView.characterLabel.text = count
            }
        }
    }
    
    override func setupAction() {
        createGroupView.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        createGroupView.presentButton.addTarget(self, action: #selector(presentButtonDidTapped), for: .touchUpInside)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        createGroupViewModel.validateName(textField.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        createGroupView.nameTextField.layer.borderColor = UIColor.gray3.cgColor
    }
    
    @objc private func presentButtonDidTapped() {
        // TODO: 서버 연결해서 초대 코드 받아올 수 있게 처리
        let inviteCodePopUpViewController = InvitationCodePopUpViewController(invitationCode: createGroupViewModel.inviteCode.value)
        
        inviteCodePopUpViewController.modalPresentationStyle = .overFullScreen
        inviteCodePopUpViewController.modalTransitionStyle = .crossDissolve
        inviteCodePopUpViewController.view.backgroundColor = .black.withAlphaComponent(0.7)
        
        present(inviteCodePopUpViewController, animated: true, completion: nil)
    }
}
