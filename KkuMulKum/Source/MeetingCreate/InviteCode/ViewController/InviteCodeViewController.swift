//
//  InviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class InviteCodeViewController: BaseViewController {
    
    
    // MARK: Property

    private let inviteCodeViewModel: InviteCodeViewModel
    
    private let inviteCodeView: InviteCodeView = InviteCodeView()
    
    
    // MARK: Initialize

    init(viewModel: InviteCodeViewModel) {
        self.inviteCodeViewModel = viewModel
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
        view = inviteCodeView
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
}


// MARK: - Extension

extension InviteCodeViewController {
    private func setupBinding() {
        inviteCodeViewModel.inviteCodeState.bind(with: self) { owner, state in
            switch state {
            case .empty:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
                owner.inviteCodeView.errorLabel.isHidden = true
                owner.inviteCodeView.checkImageView.isHidden = true
                owner.inviteCodeView.presentButton.isEnabled = false
            case .invalid:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.mainred.cgColor
                owner.inviteCodeView.errorLabel.isHidden = false
                owner.inviteCodeView.checkImageView.isHidden = true
                owner.inviteCodeView.presentButton.isEnabled = false
            case .valid:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                owner.inviteCodeView.errorLabel.isHidden = true
                owner.inviteCodeView.checkImageView.isHidden = true
                owner.inviteCodeView.presentButton.isEnabled = true
            case .success:
                owner.inviteCodeView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                owner.inviteCodeView.errorLabel.isHidden = true
                owner.inviteCodeView.checkImageView.isHidden = false
                owner.inviteCodeView.presentButton.isEnabled = true
            }
        }
        
        inviteCodeViewModel.meetingID.bind { [weak self] id in
            guard let id else { return }
            
            DispatchQueue.main.async {
                self?.inviteCodeViewModel.inviteCodeState.value = .success
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                let meetingInfoViewController = MeetingInfoViewController(
                    viewModel: MeetingInfoViewModel(
                        meetingID: id,
                        service: MeetingService()
                    )
                )
                
                guard let rootViewController = self?.navigationController?.viewControllers.first as? MainTabBarController else {
                    return
                }
                
                self?.navigationController?.popToViewController(
                    rootViewController,
                    animated: false
                )
                
                rootViewController.navigationController?.pushViewController(
                    meetingInfoViewController,
                    animated: true
                )
            }
        }
        
        inviteCodeViewModel.errorDescription.bind(with: self) { owner, error in
            DispatchQueue.main.async {
                owner.inviteCodeView.errorLabel.setText(error, style: .caption02, color: .mainred)
                owner.inviteCodeViewModel.inviteCodeState.value = .invalid
            }
        }
    }
    
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func nextButtonTapped() {
        inviteCodeViewModel.joinMeeting(inviteCode: inviteCodeViewModel.inviteCode.value)
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
