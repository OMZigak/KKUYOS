//
//  BaseCollectionViewCell.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/3/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupAction()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupAction()
        setupAutoLayout()
    }
    
    /// UI 설정 (addSubView 등)
    func setupView() {}
    
    /// RootView 내부의 액션 설정 (addTarget)
    func setupAction() {}
    
    /// 오토레이아웃 설정 (SnapKit 코드)
    func setupAutoLayout() {}
}
