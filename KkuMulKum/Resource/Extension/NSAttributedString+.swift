//
//  NSAttributedString+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import UIKit

extension NSAttributedString {
    static func pretendardString(
        _ text: String = "",
        style: UIFont.Pretendard
    ) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = style.lineHeight
        paragraphStyle.minimumLineHeight = style.lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.pretendard(style),
            .kern: style.tracking,
            .baselineOffset: style.baselineOffset
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
