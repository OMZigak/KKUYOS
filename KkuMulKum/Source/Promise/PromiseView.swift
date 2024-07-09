//
//  PromiseView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import SnapKit

class PromiseView: BaseView {
    
    let promiseSegmentedControl = PromiseSegmentedControl(items: [
        "약속 정보", 
        "준비 현황",
        "지각 꾸물이"
    ])
    
    override func setupView() {
        [
            promiseSegmentedControl
        ].forEach { self.addSubviews($0) }
    }
    
    override func setupAutoLayout() {
        promiseSegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(-6)
            $0.height.equalTo(52)
        }
    }
}
