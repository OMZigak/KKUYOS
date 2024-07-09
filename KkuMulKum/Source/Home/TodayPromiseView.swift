//
//  TodayPromiseView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/9/24.
//

import UIKit

import SnapKit
import Then


final class TodayPromiseView: BaseView {
    
    
    // MARK: - Property
    
    private let titleLabel = UILabel().then {
        $0.setText("오늘의 약속은?", style: .body01, color: .gray8)
    }
    
    private let detailButton = UIButton().then {
        let icon = UIImage(resource: .iconRight)
        $0.setImage(icon, for: .normal)
    }
    
    private let contentView = UIView().then {
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
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubviews(titleLabel, detailButton, contentView)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        detailButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(254)
        }
    }
}
