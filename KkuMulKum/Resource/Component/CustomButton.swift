//
//  CustomButton.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import UIKit

final class CustomButton: UIButton {
    static let defaultWidth: CGFloat = Screen.width(335)
    static let defaultHeight: CGFloat = Screen.height(52)
    
    override var isEnabled: Bool {
        didSet {
            updateButtonColor()
        }
    }
    
    init(title: String, isEnabled: Bool = false) {
        super.init(frame: .zero)
        setupButton(with: title, isEnabled: isEnabled)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
}

private extension CustomButton {
    func setupButton(
        with title: String = "btn",
        isEnabled: Bool = false
    ) {
        setTitle(title, style: .body03, color: .white)
        self.isEnabled = isEnabled
        layer.cornerRadius = 8
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(
            self,
            action: #selector(buttonReleased),
            for: [.touchUpInside, .touchUpOutside, .touchCancel]
        )
    }
    
    func updateButtonColor() {
        backgroundColor = isEnabled ? .maincolor : .gray2
    }
    
    @objc
    func buttonPressed() {
        backgroundColor = .green3
    }
    
    @objc
    func buttonReleased() {
        updateButtonColor()
    }
}
