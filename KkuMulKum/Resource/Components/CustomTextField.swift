//
//  CustomTextField.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import UIKit

final class CustomTextField: UITextField {
    static let defaultWidth = Screen.width(335)
    static let defaultHeight = Screen.height(48)
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        setupTextField(placeHolder: placeHolder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupTextField()
    }
}

private extension CustomTextField {
    func setupTextField(placeHolder: String = "text") {
        setText(
            placeholder: placeHolder,
            textColor: .black,
            backgroundColor: .white,
            placeholderColor: .gray3,
            style: .body04
        )
        addPadding(left: 12)
        setLayer(borderWidth: 1, borderColor: .gray3, cornerRadius: 8)
        setAutoType()
    }
}
