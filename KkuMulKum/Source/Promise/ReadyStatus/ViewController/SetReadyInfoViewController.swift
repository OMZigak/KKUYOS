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
        super.viewDidLoad()
        
        view.backgroundColor = .white
        bindViewModel()
    }
    
    override func setupDelegate() {
        setTextFieldDelegate()
    }
    
    override func setupAction() {
        rootView.readyHourTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.readyMinuteTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.moveHourTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.moveMinuteTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        viewModel.checkValid(
            readyHourText: rootView.readyHourTextField.text ?? "",
            readyMinuteText: rootView.readyMinuteTextField.text ?? "",
            moveHourText: rootView.moveHourTextField.text ?? "",
            moveMinuteText: rootView.moveMinuteTextField.text ?? ""
        )
    }
}


// MARK: - UITextFieldDelegate

extension SetReadyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.maincolor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray3.cgColor
        viewModel.updateTime(
            textField: textField.accessibilityIdentifier ?? "",
            time: textField.text ?? ""
        )
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


// MARK: - Function

private extension SetReadyInfoViewController {
    func setTextFieldDelegate() {
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
    
    func showToast(_ message: String, bottomInset: CGFloat = 128) {
        guard let view else { return }
        Toast().show(message: message, view: view, position: .bottom, inset: bottomInset)
    }
    
    
    // MARK: - Data Bind
    
    func bindViewModel() {       
        viewModel.readyHour.bind { [weak self] readyHour in
            self?.rootView.readyHourTextField.text = readyHour
        }
        
        viewModel.readyMinute.bind { [weak self] readyMinute in
            self?.rootView.readyMinuteTextField.text = readyMinute
        }
        
        viewModel.moveHour.bind { [weak self] moveHour in
            self?.rootView.moveHourTextField.text = moveHour
        }
        
        viewModel.moveMinute.bind { [weak self] moveMinute in
            self?.rootView.moveMinuteTextField.text = moveMinute
        }
        
        viewModel.isValid.bind { [weak self] isValid in
            self?.rootView.doneButton.isEnabled = isValid
        }
        
        viewModel.errMessage.bind { [weak self] err in
            if !err.isEmpty {
                self?.showToast(err)
            }
        }
    }
}
