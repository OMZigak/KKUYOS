//
//  FinishCreateNavigationView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import UIKit

class FinishCreateNavigationView: BaseView {
    let titleLabel = UILabel().then {
        $0.setText("내 모임 추가하기", style: .body03, color: .gray8)
    }
    
    let separatorView = UIView(backgroundColor: .gray1)

    override func setupView() {
        backgroundColor = .white
        
        addSubviews(
            titleLabel,
            separatorView
        )
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
