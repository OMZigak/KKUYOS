//
//  MypageView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class MyPageView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textAlignment = .center
        $0.font = UIFont.pretendard(.body03)
        $0.textColor = .black
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor.gray2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    //
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(separatorView)
    }
    
    //네비게이션바 미사용으로 UI 커스텀구현
    private func layoutViews() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(0)
        }
    }
}
