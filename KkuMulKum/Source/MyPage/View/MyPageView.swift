//
//  MyPageView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import UIKit
import SwiftUI

import SnapKit
import Then

class MyPageView: BaseView {
    private let topBackgroundView = UIView(backgroundColor: .white)
    var contentHostingController: UIHostingController<MyPageContentSwiftUIView>?
    let contentContainerView = UIView()
    let etcSettingView = MyPageEtcSettingView()
    
    override func setupView() {
        backgroundColor = .green1
        
        contentContainerView.backgroundColor = .clear
        addSubviews(topBackgroundView, contentContainerView, etcSettingView)
    }
    
    func setupSwiftUIContent(with viewModel: MyPageViewModel) {
        let swiftUIView = MyPageContentSwiftUIView(viewModel: viewModel)
        contentHostingController = UIHostingController(rootView: swiftUIView)
        
        if let hostingController = contentHostingController {
            hostingController.view.backgroundColor = .clear
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            
            contentContainerView.addSubview(hostingController.view)
            
            // SwiftUI 뷰에 오토레이아웃 제약 추가
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
            ])
        }
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeArea.snp.top)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
            // 기존 MyPageContentView의 높이와 동일하게 설정
            // top padding(24) + profileStackView(120) + spacing(12) + levelView(36) + spacing(35) + separator(6) + bottom(25)
            $0.height.equalTo(24 + Screen.height(120) + 12 + Screen.height(36) + 35 + Screen.height(6) + 25)
        }
        
        etcSettingView.snp.makeConstraints {
            $0.top.equalTo(contentContainerView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeArea).offset(-127)
        }
    }
}
