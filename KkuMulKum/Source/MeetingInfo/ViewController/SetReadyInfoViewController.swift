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
    }
}


// MARK: - UITextFieldDelegate

extension SetReadyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.maincolor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray3.cgColor
    }
}
