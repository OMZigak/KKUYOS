//
//  SetReadyInfoViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/15/24.
//

import UIKit

final class SetReadyInfoViewModel {
    var isValid = ObservablePattern<Bool>(false)
    var errMessage = ObservablePattern<String>("")
    
//    var readyHour = ObservablePattern<String?>(nil)
//    var readyMinute = ObservablePattern<String?>(nil)
//    var moveHour = ObservablePattern<String?>(nil)
//    var moveMinute = ObservablePattern<String?>(nil)
    
    func validateTextField(for textField: UITextField) {
        guard let text = textField.text, let time = Int(text) else { return }
        
        if textField.accessibilityIdentifier == "readyHour" || textField.accessibilityIdentifier == "moveHour" {
            if time >= 24 {
                textField.text = "23"
                errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
                print(errMessage.value)
                return
            }
        } else if textField.accessibilityIdentifier == "readyMinute" || textField.accessibilityIdentifier == "moveMinute" {
            if time >= 60 {
                textField.text = "59"
                errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
                print(errMessage.value)
                return
            }
        }
        
        isValid.value = true
    }
}
