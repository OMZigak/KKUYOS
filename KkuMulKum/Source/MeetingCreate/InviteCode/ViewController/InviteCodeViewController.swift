//
//  InviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class InviteCodeViewController: BaseViewController {
    private let inviteCodeViewModel: InviteCodeViewModel = InviteCodeViewModel(service: MockInviteCodeService())
    
    private let inviteCodeView: InviteCodeView = InviteCodeView()
    
    override func loadView() {
        view = inviteCodeView
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
        inviteCodeViewModel.inviteCodeState.bind(with: self) { owner, state in
            switch state {
            case .empty:
                self.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
                self.inviteCodeView.errorLabel.isHidden = true
                self.inviteCodeView.checkImageView.isHidden = true
            case .invalid:
                self.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.mainred.cgColor
                self.inviteCodeView.errorLabel.isHidden = false
                self.inviteCodeView.checkImageView.isHidden = true
            case .valid:
                self.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                self.inviteCodeView.errorLabel.isHidden = true
                self.inviteCodeView.checkImageView.isHidden = true
            case .success:
                self.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                self.inviteCodeView.errorLabel.isHidden = true
                self.inviteCodeView.checkImageView.isHidden = false
                self.inviteCodeView.presentButton.isEnabled = true
            }
        }
    }
    
    override func setupAction() {
        inviteCodeView.inviteCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        inviteCodeView.presentButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func setupDelegate() {
        inviteCodeView.inviteCodeTextField.delegate = self
        inviteCodeView.inviteCodeTextField.returnKeyType = .done
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func nextButtonTapped() {
        // TODO: 서버 연결할 때 데이터 바인딩해서 화면 전환 시키기
        let promiseViewController = BasePromiseViewController()
        
        promiseViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(promiseViewController, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        inviteCodeViewModel.validateCode(textField.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
    }
}

extension InviteCodeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch inviteCodeViewModel.inviteCodeState.value {
        case .empty:
            inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
        case .valid, .success:
            inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
        case .invalid:
            inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.mainred.cgColor
        }
        
        return true
    }
}

