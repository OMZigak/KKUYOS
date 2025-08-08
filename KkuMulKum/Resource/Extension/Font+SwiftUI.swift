//
//  Font+SwiftUI.swift
//  KkuMulKum
//
//  Created by SwiftUI Migration on 2025/01/08.
//

import SwiftUI

extension Font {
    static func pretendard(_ style: UIFont.Pretendard) -> Font {
        return Font.custom(style.weight, size: style.size)
    }
    
    // Convenience methods for common styles
    static var pretendardTitle00: Font { pretendard(.title00) }
    static var pretendardTitle01: Font { pretendard(.title01) }
    static var pretendardTitle02: Font { pretendard(.title02) }
    static var pretendardHead01: Font { pretendard(.head01) }
    static var pretendardHead02: Font { pretendard(.head02) }
    static var pretendardBody01: Font { pretendard(.body01) }
    static var pretendardBody02: Font { pretendard(.body02) }
    static var pretendardBody03: Font { pretendard(.body03) }
    static var pretendardBody04: Font { pretendard(.body04) }
    static var pretendardBody05: Font { pretendard(.body05) }
    static var pretendardBody06: Font { pretendard(.body06) }
    static var pretendardCaption01: Font { pretendard(.caption01) }
    static var pretendardCaption02: Font { pretendard(.caption02) }
    static var pretendardLabel00: Font { pretendard(.label00) }
    static var pretendardLabel01: Font { pretendard(.label01) }
    static var pretendardLabel02: Font { pretendard(.label02) }
}

// SwiftUI Color extension for UIKit colors
extension Color {
    init(uiColor: UIColor) {
        self.init(uiColor)
    }
}