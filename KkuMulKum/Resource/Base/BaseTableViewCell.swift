//
//  BaseTableViewCell.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/3/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell, ReuseIdentifiable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
