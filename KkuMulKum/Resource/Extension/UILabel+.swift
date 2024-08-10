//
//  UILabel+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import UIKit

extension UILabel {
    func setText(
        _ text: String,
        style: UIFont.Pretendard,
        color: UIColor = .black,
        isSingleLine: Bool = false
    ) {
        attributedText = .pretendardString(text, style: style)
        textColor = color
        if isSingleLine {
            numberOfLines = 1
            lineBreakMode = .byTruncatingTail
        } else {
            numberOfLines = 0
        }
    }
    
    func updateText(_ text: String) {
        guard let currentAttributes = attributedText?.attributes(at: 0, effectiveRange: nil) else {
            self.text = text
            return
        }
        attributedText = NSAttributedString(string: text, attributes: currentAttributes)
    }
    
    func setHighlightText(_ words: String..., style: UIFont.Pretendard, color: UIColor? = nil) {
        guard let currentText = attributedText?.string else { return }
        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedText ?? NSAttributedString()
        )
        let textColor = textColor ?? .black
        
        for word in words {
            let range = (currentText as NSString).range(of: word)
            
            if range.location != NSNotFound {
                let highlightedAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.pretendard(style),
                    .foregroundColor: color ?? textColor
                ]
                mutableAttributedString.addAttributes(highlightedAttributes, range: range)
                attributedText = mutableAttributedString
            }
        }
    }
}
