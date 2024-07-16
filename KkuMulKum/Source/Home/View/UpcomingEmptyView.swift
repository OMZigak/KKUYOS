//
//  UpcomingEmptyView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class UpcomingEmptyView: BaseView {
    
    
    // MARK: - Property
    
    private let emptyLabel = UILabel().then {
        $0.setText("아직 약속이 없네요!\n약속을 추가해 보세요!", style: .body05, color: .gray3)
        $0.setHighlightText("약속을 추가", style: .body05, color: .maincolor)
        $0.textAlignment = .center
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubview(emptyLabel)
    }
    
    override func setupAutoLayout() {
        emptyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
