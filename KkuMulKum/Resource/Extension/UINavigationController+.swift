//
//  UINavigationController+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 8/19/24.
//

import UIKit

import SnapKit
import Then

extension UINavigationController {
    fileprivate static let borderLine = UIView(backgroundColor: .gray2)
    
    func hideBorder() {
        Self.borderLine.isHidden = true
    }
    
    func showBorder() {
        Self.borderLine.isHidden = false
    }
}

extension UINavigationController {
    convenience init(rootViewController: UIViewController, isBorderNeeded: Bool) {
        self.init(rootViewController: rootViewController)
        
        addBorder()
    }
    
    private func addBorder() {
        let border = Self.borderLine
        
        if !navigationBar.subviews.contains(where: { $0 == border }) {
            navigationBar.addSubviews(border)
            
            border.snp.makeConstraints {
                $0.horizontalEdges.bottom.equalToSuperview()
                $0.height.equalTo(Screen.height(1))
            }
        }
    }
}
