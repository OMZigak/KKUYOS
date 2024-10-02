//
//  MyPageEtcSettingView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class MyPageEtcSettingView: BaseView {
    let stackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    let versionInfoRow = UIView()
    let termsOfServiceRow = UIView()
    let inquiryRow = UIView()
    let logoutRow = UIView()
    let unsubscribeRow = UIView()
    
    override func setupView() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray2.cgColor
        layer.cornerRadius = 8
        
        setupRows()
        
        stackView.addArrangedSubviews(versionInfoRow,termsOfServiceRow,inquiryRow,logoutRow,unsubscribeRow)
        addSubviews(stackView)
    }
    
    override func setupAutoLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(22)
        }
    }
    
    private func setupRows() {
        setupRow(versionInfoRow, title: "버전정보", subtitle: "1.0.2")
        setupRow(termsOfServiceRow, title: "이용약관")
        setupRow(inquiryRow, title: "문의하기")
        setupRow(logoutRow, title: "로그아웃")
        setupRow(unsubscribeRow, title: "탈퇴하기")
    }
    
    private func setupRow(_ row: UIView, title: String, subtitle: String? = nil) {
        let titleLabel = UILabel().then {
            $0.setText(title, style: .body03, color: .gray7)
        }
        row.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel().then {
                $0.setText(subtitle, style: .body03, color: .gray8)
            }
            row.addSubviews(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.verticalEdges.equalToSuperview()
            }
        }
        
        let tapGesture = UITapGestureRecognizer()
        row.addGestureRecognizer(tapGesture)
        row.isUserInteractionEnabled = true
    }
}
