//
//  SelectCapsuleButton.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

final class SelectCapsuleButton: UIButton {
    static let defaultHeight = Screen.height(40)
    
    var identifier: String {
        accessibilityIdentifier ?? ""
    }
    
    override var isSelected: Bool {
        didSet {
            configureButton(with: isSelected)
        }
    }
    
    // MARK: - Initializer

    init(title: String, identifier: String? = nil) {
        super.init(frame: .zero)
        accessibilityIdentifier = identifier != nil ? identifier : title
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension SelectCapsuleButton {
    func setupButton(title: String = "") {
        backgroundColor = .white
        setTitle(title, style: .body04, color: .gray5)
        setLayer(borderWidth: 1, borderColor: .gray2, cornerRadius: 20)
    }
    
    func configureButton(with isSelected: Bool) {
        let backgroundColor: UIColor = isSelected ? .green2 : .white
        let titleColor: UIColor = isSelected ? .green3 : .gray5
        let borderColor: UIColor = isSelected ? .green3 : .gray2
        
        
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        layer.borderColor = borderColor.cgColor
    }
}
