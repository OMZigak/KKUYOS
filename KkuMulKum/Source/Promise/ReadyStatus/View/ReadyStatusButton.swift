//
//  ReadyStatusButton.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import UIKit

enum ReadyStatus {
    case none
    case ready
    case boarding
    case done
}

class ReadyStatusButton: UIButton {
    static let defaultWidth: CGFloat = Screen.width(335)
    static let defaultHeight: CGFloat = Screen.height(52)
    
    init(readyStatus: ReadyStatus) {
        super.init(frame: .zero)
        
        setupButton(title, readyStatus)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension ReadyStatusButton {
    func setupButton(
        _ title: String,
        _ readyStatus: ReadyStatus
    ) {
    switch readyStatus {
    case .none:
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray3.cgColor
        setTitle(title, style: .body05, color: .gray3)
    case .ready:
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray3.cgColor
        setTitle(title, style: .body05, color: .gray3)
    case .boarding:
        self.backgroundColor = .green2
        self.layer.borderColor = UIColor.maincolor.cgColor
        setTitle(title, style: .body05, color: .gray3)
    case .done:
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray3.cgColor
        setTitle(title, style: .body05, color: .gray3)
    }
        
    }
    
    func updateButtonColor() {
        backgroundColor = isEnabled ? .maincolor : .gray2
    }
    
    @objc
    func buttonPressed() {
        rea
    }
    
    @objc
    func buttonReleased() {
        updateButtonColor()
    }
}
