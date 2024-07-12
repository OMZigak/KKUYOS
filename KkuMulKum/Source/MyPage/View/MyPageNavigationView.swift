//
//  MypageView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class MyPageNavigationView: BaseView {
    let titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textAlignment = .center
        $0.font = UIFont.pretendard(.body03)
        $0.textColor = .black
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = .gray1
    }

    override func setupView() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(separatorView)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        separatorView.snp.makeConstraints { 
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
