//
//  HomeView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/9/24.
//

import UIKit

import Then
import SnapKit


// MARK: - HomeView

final class HomeView: BaseView {
    
    
    // MARK: - Property
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .gray0
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .maincolor
    }
    
    private let promiseView = UIView().then {
        $0.backgroundColor = .gray0
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    private let todayPromiseView = TodayPromiseView()
    
    private let upcomingPromiseView = UpcomingPromiseView()
    
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(promiseView)
        promiseView.addSubviews(todayPromiseView, upcomingPromiseView)
    }
    
    override func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        promiseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(646)
            $0.top.equalToSuperview().offset(350)
            $0.bottom.equalTo(contentView)
        }
        
        todayPromiseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(298)
        }
        
        upcomingPromiseView.snp.makeConstraints {
            $0.top.equalTo(todayPromiseView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(298)
        }
    }
}
