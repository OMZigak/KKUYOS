//
//  InviteCodeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class InviteCodeViewController: BaseViewController {
    
    
    // MARK: Property

    private let viewModel: InviteCodeViewModel
    private let rootView: InviteCodeView = InviteCodeView()
    
    
    // MARK: - LifeCycle
    
    init(viewModel: InviteCodeViewModel) {
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
        setupTapGesture()
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
        rootView.inviteCodeTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        rootView.presentButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        rootView.inviteCodeTextField.delegate = self
        rootView.inviteCodeTextField.returnKeyType = .done
    }
}


// MARK: - Extension

extension InviteCodeViewController {
    private func setupBinding() {
        viewModel.inviteCodeState.bind(with: self) { owner, state in
            owner.rootView.errorLabel.isHidden = true
            owner.rootView.checkImageView.isHidden = true
            owner.rootView.presentButton.isEnabled = false
            
            switch state {
            case .empty:
                owner.rootView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
            case .invalid:
                owner.rootView.inviteCodeTextField.layer.borderColor = UIColor.mainred.cgColor
                owner.rootView.errorLabel.isHidden = false
            case .valid:
                owner.rootView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                owner.rootView.presentButton.isEnabled = true
            case .success:
                owner.rootView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
                owner.rootView.checkImageView.isHidden = false
                owner.rootView.presentButton.isEnabled = true
            }
        }
        
        viewModel.meetingID.bind { [weak self] id in
            guard let id else { return }
            
            DispatchQueue.main.async {
                self?.viewModel.inviteCodeState.value = .success
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                let meetingInfoViewController = MeetingInfoViewController(
                    viewModel: MeetingInfoViewModel(
                        meetingID: id,
                        service: MeetingService()
                    )
                )
                
                guard let navigationController = self?.navigationController,
                      let rootViewController = navigationController.viewControllers.first as? MainTabBarController else {
                    return
                }

                navigationController.setViewControllers([rootViewController, meetingInfoViewController], animated: true)
            }
        }
        
        viewModel.errorDescription.bind(with: self) { owner, error in
            DispatchQueue.main.async {
                owner.rootView.errorLabel.setText(error, style: .caption02, color: .mainred)
                owner.viewModel.inviteCodeState.value = .invalid
            }
        }
        
        viewModel.inviteCode.bind { code in
            self.viewModel.validateInviteCode()
        }
    }
    
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func nextButtonTapped() {
        viewModel.joinMeeting()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.updateInviteCode(textField.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        
        rootView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
    }
}


// MARK: - UITextFieldDelegate

extension InviteCodeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        rootView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch viewModel.inviteCodeState.value {
        case .empty:
            rootView.inviteCodeTextField.layer.borderColor = UIColor.gray3.cgColor
        case .valid, .success:
            rootView.inviteCodeTextField.layer.borderColor = UIColor.maincolor.cgColor
        case .invalid:
            rootView.inviteCodeTextField.layer.borderColor = UIColor.mainred.cgColor
        }
        
        return true
    }
}
