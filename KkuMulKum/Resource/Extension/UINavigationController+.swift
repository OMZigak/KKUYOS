//
//  UINavigationController+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 8/19/24.
//

import UIKit

extension UINavigationController {
    convenience init(rootViewController: UIViewController, isBorderNeeded: Bool) {
        self.init(rootViewController: rootViewController)
        
        if isBorderNeeded {
            addBorder()
        }
    }
    
    func showBorder() {
        let border = findBottomBorder()
        border?.isHidden = false
    }
    
    func hideBorder() {
        let border = findBottomBorder()
        border?.isHidden = true
    }
}

private extension UINavigationController {
    enum Constants {
        static let bottomBorderName = "BottomBorder"
        static let bottomBorderWidth: CGFloat = Screen.height(1)
    }
    
    func addBorder() {
        guard findBottomBorder() == nil else { return }
        
        let border = CALayer()
        border.name = Constants.bottomBorderName
        border.backgroundColor = UIColor.gray2.cgColor
        border.frame = CGRect(
            x: 0,
            y: navigationBar.frame.height - Constants.bottomBorderWidth,
            width: navigationBar.frame.width,
            height: Constants.bottomBorderWidth
        )
        
        navigationBar.layer.addSublayer(border)
    }
    
    func findBottomBorder() -> CALayer? {
        return navigationBar.layer.sublayers?.first(where: { $0.name == Constants.bottomBorderName })
    }
}
