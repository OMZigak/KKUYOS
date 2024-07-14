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
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setTextFieldDelegate()
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
    }
}


// MARK: - UITextFieldDelegate

extension SetReadyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.maincolor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray3.cgColor
        validateTextField(textField)
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
    
    private func validateTextField(_ textField: UITextField) {
        guard let text = textField.text, let value = Int(text) else { return }
        
        if textField == rootView.readyHourTextField || textField == rootView.moveHourTextField {
            if value >= 24 {
                textField.text = "23"
            }
        }
        if textField == rootView.readyMinuteTextField || textField == rootView.moveMinuteTextField {
            if value >= 60 {
                textField.text = "59"
            }
        }
    }
}
