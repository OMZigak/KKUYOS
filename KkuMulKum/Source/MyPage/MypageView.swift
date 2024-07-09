//
//  MypageView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//
import UIKit

import SnapKit
import Then

class MyPageView: BaseView {

    private let titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textAlignment = .center
        $0.font = UIFont.pretendard(.body03)
        $0.textColor = .black
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor.gray2
    }
    
    // 배경색을 설정할 추가 뷰
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
    }

    override func setupView() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(separatorView)
    }

    override func setupAutoLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
