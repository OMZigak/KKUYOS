//
//  UILabel+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import UIKit

extension UILabel {
    func setText(
        _ text: String = " ",
        style: UIFont.Pretendard,
        color: UIColor = .black,
        isSingleLine: Bool = false
    ) {
        attributedText = .pretendardString(text.isEmpty ? " " : text, style: style)
        textColor = color
        if isSingleLine {
            numberOfLines = 1
            lineBreakMode = .byTruncatingTail
        } else {
            numberOfLines = 0
        }
    }
    
    func updateText(_ text: String?) {
        guard let currentAttributes = attributedText?.attributes(at: 0, effectiveRange: nil) else {
            self.text = text
            return
        }
        attributedText = NSAttributedString(string: text ?? " ", attributes: currentAttributes)
    }
    
    /// 단일 단어를 하이라이트할 때
    func setHighlightText(_ words: String..., style: UIFont.Pretendard, color: UIColor? = nil) {
        guard let currentAttributedText = attributedText else { return }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: currentAttributedText)
        let textColor = textColor ?? .black
        
        for word in words {
            let range = (currentAttributedText.string as NSString).range(of: word)
            
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
    
    /// 여러 단어를 하이라이트할 때, 순차적으로 하이라이트하여 동일한 단어를 처리
    func setHighlightText(for words: [String], style: UIFont.Pretendard, color: UIColor? = nil) {
        guard let currentAttributedText = attributedText else { return }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: currentAttributedText)
        let textColor = color ?? self.textColor ?? .black
        
        for word in words {
            var searchRange = NSRange(location: 0, length: currentAttributedText.length)
            
            while searchRange.location < currentAttributedText.length {
                let range = (currentAttributedText.string as NSString).range(
                    of: word,
                    options: [],
                    range: searchRange
                )
                
                if range.location != NSNotFound {
                    let highlightedAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.pretendard(style),
                        .foregroundColor: textColor
                    ]
                    mutableAttributedString.addAttributes(highlightedAttributes, range: range)
                    
                    /// 다음 검색 범위를 설정
                    searchRange = NSRange(
                        location: range.location + range.length,
                        length: currentAttributedText.length - (range.location + range.length)
                    )
                } else {
                    break
                }
            }
        }
        
        attributedText = mutableAttributedString
    }
}
