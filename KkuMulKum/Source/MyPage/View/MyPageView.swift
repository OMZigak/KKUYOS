//
//  MyPageView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import UIKit

import SnapKit
import Then

class MyPageView: BaseView {
    private let topBackgroundView = UIView(backgroundColor: .white)
    private let contentView = MyPageContentView()
     let etcSettingView = MyPageEtcSettingView()
    
    override func setupView() {
        backgroundColor = .green1
        
        addSubviews(topBackgroundView, contentView, etcSettingView)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeArea.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
        }
        
        etcSettingView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeArea).offset(-60)
        }
    }
}
