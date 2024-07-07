//
//  Screen.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import UIKit

enum Screen {
    static func width(_ value: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let designWidth: CGFloat = 375.0
        return screenWidth / designWidth * value
    }
    
    static func height(_ value: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let designHeight: CGFloat = 812.0
        return screenHeight / designHeight * value
    }
}
