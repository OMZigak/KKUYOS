//
//  NicknameViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

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
        let profileSetupVC = ProfileSetupViewController(
            viewModel: ProfileSetupViewModel(
                nickname: viewModel.nickname.value
            )
        )
//        profileSetupVC.modalPresentationStyle = .fullScreen
//        present(profileSetupVC, animated: true, completion: nil)
        // TODO: 온보딩 플로우 네비게이션으로 실행
        navigationController?.pushViewController(profileSetupVC, animated: true)
        
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
