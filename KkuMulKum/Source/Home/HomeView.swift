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
            $0.height.equalTo(700)
            $0.top.equalToSuperview().offset(350)
            $0.bottom.equalTo(contentView)
        }
    }
}
