//
//  NicknameViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//
// NicknameViewController.swift

import UIKit

class NicknameViewController: BaseViewController {
    
    private let nicknameView = NicknameView()
    private let viewModel = NicknameViewModel()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTextField()
        setupTapGesture()
        setupNavigationBarTitle(with: "닉네임 설정")
        
        print("---")
        let keychainService = DefaultKeychainService.shared
        
        if let accessToken = keychainService.accessToken {
            print("Access token is available in NicknameViewController: \(accessToken)")
        } else {
            print("No access token available in NicknameViewController. User may need to log in.")
        }
    }
    
    override func setupAction() {
        nicknameView.nicknameTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        nicknameView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupBindings() {
        viewModel.nicknameState.bind { [weak self] state in
            switch state {
            case .empty:
                self?.nicknameView.nicknameTextField.layer.borderColor = UIColor.gray3.cgColor
                self?.nicknameView.errorLabel.isHidden = true
            case .valid:
                self?.nicknameView.nicknameTextField.layer.borderColor = UIColor.maincolor.cgColor
                self?.nicknameView.errorLabel.isHidden = true
            case .invalid:
                self?.nicknameView.nicknameTextField.layer.borderColor = UIColor.red.cgColor
                self?.nicknameView.errorLabel.isHidden = false
            }
        }
        
        viewModel.errorMessage.bind { [weak self] errorMessage in
            self?.nicknameView.errorLabel.text = errorMessage
        }
        
        viewModel.isNextButtonEnabled.bind { [weak self] isEnabled in
            self?.nicknameView.nextButton.isEnabled = isEnabled
            self?.nicknameView.nextButton.backgroundColor = isEnabled ? .maincolor : .gray2
        }
        
        viewModel.characterCount.bind { [weak self] count in
            self?.nicknameView.characterCountLabel.text = count
        }
        
        viewModel.serverResponse.bind { response in
            if let response = response {
                print("서버 응답: \(response)")
            }
        }
    }
    
    private func setupTextField() {
        nicknameView.nicknameTextField.delegate = self
        nicknameView.nicknameTextField.returnKeyType = .done
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.validateNickname(textField.text ?? "")
    }
    
    @objc private func nextButtonTapped() {
        viewModel.updateNickname { [weak self] success in
            if success {
                print("닉네임이 성공적으로 서버에 등록되었습니다.")
                let profileSetupVC = ProfileSetupViewController(
                    viewModel: ProfileSetupViewModel(
                        nickname: self?.viewModel.nickname.value ?? ""
                    )
                )
                self?.navigationController?.pushViewController(profileSetupVC, animated: true)
            } else {
                print("닉네임 등록에 실패했습니다.")
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        nicknameView.nicknameTextField.layer.borderColor = UIColor.gray3.cgColor
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nicknameView.nicknameTextField.layer.borderColor = UIColor.gray3.cgColor
        return true
    }
}
