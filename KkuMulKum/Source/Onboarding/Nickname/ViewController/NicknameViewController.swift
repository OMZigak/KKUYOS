//
//  NicknameViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class NicknameViewController: BaseViewController, UITextFieldDelegate {
    
    private let nicknameView = NicknameView()
    private let viewModel = NicknameViewModel()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupActions()
        setupTextField()
        setupTapGesture()
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

    private func setupActions() {
        nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nicknameView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        print("Next button tapped with nickname: \(viewModel.nickname.value)")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        nicknameView.nicknameTextField.layer.borderColor = UIColor.gray3.cgColor
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nicknameView.nicknameTextField.layer.borderColor = UIColor.gray3.cgColor
        return true
    }
}
