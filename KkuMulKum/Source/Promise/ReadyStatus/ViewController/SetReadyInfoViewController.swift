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
    private let viewModel: SetReadyInfoViewModel
    
    
    // MARK: - Initializer
    
    init(viewModel: SetReadyInfoViewModel) {
        self.viewModel = viewModel
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
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "준비 정보 입력하기")
        
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
        rootView.doneButton.addTarget(
            self,
            action: #selector(doneButtonDidTap),
            for: .touchUpInside
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
    
    @objc
    private func doneButtonDidTap(_ sender: UIButton) {
        viewModel.updateReadyInfo()
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
        let textFields: [(UITextField, String)] = [
            (rootView.readyHourTextField, "readyHour"),
            (rootView.readyMinuteTextField, "readyMinute"),
            (rootView.moveHourTextField, "moveHour"),
            (rootView.moveMinuteTextField, "moveMinute")
        ]
        
        textFields.forEach { (textField, identifier) in
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.accessibilityIdentifier = identifier
        }
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
        
        viewModel.isSucceedToSave.bind { [weak self] _ in
            if self?.viewModel.isSucceedToSave.value == true {
                DispatchQueue.main.async {
                    let viewController = SetReadyCompletedViewController()
                    self?.navigationController?.pushViewController(
                        viewController,
                        animated: true
                    )
                }
            }
        }
    }
}
