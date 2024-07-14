//
//  InviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class InviteCodeViewController: BaseViewController {
    private let inviteCodeViewModel: InviteCodeViewModel
    
    private let inviteCodeView: InviteCodeView = InviteCodeView()
    
    init(viewModel: InviteCodeViewModel) {
        self.inviteCodeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func setupAction() {
        inviteCodeView.inviteCodeTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        inviteCodeView.presentButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        inviteCodeView.inviteCodeTextField.delegate = self
        inviteCodeView.inviteCodeTextField.returnKeyType = .done
    }
    
    private func setupBinding() {
        inviteCodeViewModel.inviteCodeState.bind(with: self) { owner, state in
            switch state {
            case .empty:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
                owner.inviteCodeView.errorLabel.isHidden = true
                owner.inviteCodeView.checkImageView.isHidden = true
            case .invalid:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.mainred.cgColor
                owner.inviteCodeView.errorLabel.isHidden = false
                owner.inviteCodeView.checkImageView.isHidden = true
            case .valid:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                owner.inviteCodeView.errorLabel.isHidden = true
                owner.inviteCodeView.checkImageView.isHidden = true
            case .success:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                owner.inviteCodeView.errorLabel.isHidden = true
                owner.inviteCodeView.checkImageView.isHidden = false
                owner.inviteCodeView.presentButton.isEnabled = true
            }
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func nextButtonTapped() {
        // TODO: 서버 연결할 때 데이터 바인딩해서 화면 전환 시키기
        let basePromiseViewController = PagePromiseViewController()
        
        navigationController?.pushViewController(basePromiseViewController, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        inviteCodeViewModel.validateCode(textField.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
    }
}


// MARK: - UITextFieldDelegate

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
