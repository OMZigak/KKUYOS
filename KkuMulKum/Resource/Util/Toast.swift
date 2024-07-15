//
//  Toast.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/11/24.
//

import UIKit

import SnapKit

final class Toast: UIView {
    enum Position {
        case top, bottom
    }
    
    func show(message: String, view: UIView, position: Position, inset: CGFloat) {
        setupToastAppearance()
        
        let toastLabel = setupToastLabel(with: message)
        
        view.addSubview(self)
        addSubview(toastLabel)
        
        setPositionConstraints(position: position, inset: inset)
        
        toastLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
        
        animateToast()
    }
}

private extension Toast {
    func setupToastLabel(with message: String) -> UILabel {
        let toastLabel = UILabel().then {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = message
            $0.font = .pretendard(.body06)
            $0.clipsToBounds = true
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        return toastLabel
    }
    
    func setupToastAppearance() {
        layer.cornerRadius = 20
        backgroundColor = .black.withAlphaComponent(0.4)
        isUserInteractionEnabled = false
    }
    
    func setPositionConstraints(position: Position, inset: CGFloat) {
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            switch position {
            case .top:
                $0.top.equalToSuperview().inset(inset)
            case .bottom:
                $0.bottom.equalToSuperview().inset(inset)
            }
        }
    }
    
    func animateToast() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 1.8, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        })
    }
}
