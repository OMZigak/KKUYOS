//
//  UIButton+.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String, style: UIFont.Pretendard, color: UIColor) {
        setAttributedTitle(.pretendardString(title, style: style), for: .normal)
        setTitleColor(color, for: .normal)
    }
    
    func setLayer(borderWidth: CGFloat = 0, borderColor: UIColor, cornerRadius: CGFloat) {
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
    
    func addUnderline() {
        let attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func addUnderlineWithMyPage(
        textColor: UIColor,
        underlineColor: UIColor = .gray2,
        spacing: CGFloat = 12
    ) {
        let font = UIFont.pretendard(.body05)
        let underlineStyle = NSUnderlineStyle.single
       
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .underlineStyle: underlineStyle.rawValue,
            .underlineColor: underlineColor,
            .baselineOffset: spacing / 2
        ]
        
        let attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "", attributes: attributes)
        setAttributedTitle(attributedString, for: .normal)
    }
}
