//
//  ReadyStatusButton.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import UIKit

enum ReadyProgressStatus {
    case none
    case ready
    case move
    case done
}

class ReadyStatusButton: UIButton {
    init(title: String, readyStatus: ReadyProgressStatus) {
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

extension ReadyStatusButton {
    func setupButton(
        _ title: String,
        _ readyStatus: ReadyProgressStatus
    ) {
        switch readyStatus {
        case .none:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.gray3.cgColor
            setTitle(title, style: .body05, color: .gray3)
        case .ready:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.maincolor.cgColor
            setTitle(title, style: .body05, color: .maincolor)
        case .move:
            self.backgroundColor = .green2
            self.layer.borderColor = UIColor.maincolor.cgColor
            setTitle(title, style: .body05, color: .maincolor)
        case .done:
            self.backgroundColor = .maincolor
            self.layer.borderColor = UIColor.maincolor.cgColor
            setTitle(title, style: .body05, color: .white)
        }
    }
}
