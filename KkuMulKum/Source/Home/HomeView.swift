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
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .maincolor
    }
    
    private let promiseView = UIView().then {
        $0.backgroundColor = .gray0
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    private let todayLabel = UILabel().then {
        $0.setText("오늘의 약속은?", style: .body01, color: .gray8)
    }
    
    private let todayButton = UIButton().then {
        let icon = UIImage(resource: .iconRight)
        $0.setImage(icon, for: .normal)
    }
    
    private let todayPromiseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    private let upcomingLabel = UILabel().then {
        $0.setText("다가올 나의 약속은?", style: .body01, color: .gray8)
    }
    
    private let upcomingPromiseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    
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
        promiseView.addSubviews(
            todayLabel,
            todayButton,
            todayPromiseView,
            upcomingLabel,
            upcomingPromiseView
        )
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
        
        todayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(16)
        }
        
        todayButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(todayLabel.snp.centerY)
            $0.size.equalTo(20)
        }
        
        todayPromiseView.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(254)
        }
        
        upcomingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(342)
        }
        
        upcomingPromiseView.snp.makeConstraints {
            $0.top.equalTo(upcomingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(216)
        }
    }
}
