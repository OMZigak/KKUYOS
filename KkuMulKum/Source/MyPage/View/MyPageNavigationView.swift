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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        backgroundColor = .white
        addSubview(titleLabel)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
