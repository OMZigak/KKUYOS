//
//  SetReadyInfoViewController.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/14/24.
//

import UIKit

final class SetReadyInfoViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = SetReadyInfoView()
    
    private let viewModel = SetReadyInfoViewModel()
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setTextFieldDelegate()
        bindViewModel()
    }
    
    private func setTextFieldDelegate() {
        rootView.readyHourTextField.delegate = self
        rootView.readyMinuteTextField.delegate = self
        rootView.moveHourTextField.delegate = self
        rootView.moveMinuteTextField.delegate = self
        
        rootView.readyHourTextField.keyboardType = .numberPad
        rootView.readyMinuteTextField.keyboardType = .numberPad
        rootView.moveHourTextField.keyboardType = .numberPad
        rootView.moveMinuteTextField.keyboardType = .numberPad
        
        rootView.readyHourTextField.accessibilityIdentifier = "readyHour"
        rootView.readyMinuteTextField.accessibilityIdentifier = "readyMinute"
        rootView.moveHourTextField.accessibilityIdentifier = "moveHour"
        rootView.moveMinuteTextField.accessibilityIdentifier = "moveMinute"
    }
    
    private func bindViewModel() {
        viewModel.isValid.bind { [weak self] isValid in
            if isValid {
                self?.rootView.doneButton.isEnabled = true
            }
        }
        
        viewModel.errMessage.bind { [weak self] err in
            if !err.isEmpty {
                self?.showToast(err)
            }
        }
    }
    
    func showToast(_ message: String, bottomInset: CGFloat = 128) {
        guard let view else { return }
        Toast().show(message: message, view: view, position: .bottom, inset: bottomInset)
    }
}


// MARK: - UITextFieldDelegate

extension SetReadyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.maincolor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray3.cgColor
        viewModel.validateTextField(for: textField)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
