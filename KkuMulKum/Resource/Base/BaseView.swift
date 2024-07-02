//
//  BaseView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/3/24.
//

import UIKit

import Then

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupAutoLayout()
    }
    
    /// UI 설정 (addSubView 등)
    func setupView() {}
    
    /// 오토레이아웃 설정 (SnapKit 코드)
    func setupAutoLayout() {}
}
