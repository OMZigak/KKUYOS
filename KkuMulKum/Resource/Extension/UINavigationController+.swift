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
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        barAppearance.shadowColor = isBorderNeeded ? .gray2 : nil
        
        navigationBar.standardAppearance = barAppearance
        navigationBar.scrollEdgeAppearance = barAppearance
    }
}
