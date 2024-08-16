//
//  UIFont+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import UIKit

extension UIFont {
    static func pretendard(_ style: Pretendard) -> UIFont {
        return UIFont(name: style.weight, size: style.size) ?? .systemFont(ofSize: style.size)
    }
    
    enum Pretendard {
        private static let scaleRatio: CGFloat = max(Screen.height(1), Screen.width(1))
        
        case title00, title01, title02
        case head01, head02
        case body01, body02, body03, body04, body05, body06
        case caption01, caption02
        case label00, label01, label02
        
        var weight: String {
            switch self {
            case .title00:
                "Pretendard-Bold"
            case .title01, .head01, .body01, .body03, .body05, .caption01, .label01:
                "Pretendard-SemiBold"
            case .title02, .head02, .body02, .body04, .body06, .caption02, .label00, .label02:
                "Pretendard-Regular"
            }
        }
        
        var size: CGFloat {
            return defaultSize * Pretendard.scaleRatio
        }
        
        private var defaultSize: CGFloat {
            switch self {
            case .title00, .title01, .title02: 24
            case .head01, .head02: 22
            case .body01, .body02: 18
            case .body03, .body04: 16
            case .body05, .body06: 14
            case .caption01, .caption02, .label00: 12
            case .label01, .label02: 10
            }
        }
        
        var tracking: CGFloat { CGFloat(-2) / 100 * size }
        
        var lineHeight: CGFloat {
            switch self {
            case .label00: 1.38 * size
            default: 1.6 * size
            }
        }
        
        var baselineOffset: CGFloat { return (lineHeight - size) / 4 }
    }
}
