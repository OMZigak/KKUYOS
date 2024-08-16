//
//  MeetingInfoBannerView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class MeetingInfoBannerView: BaseView {
    private let explanationLabel = UILabel().then {
        $0.setText("모임 생성일", style: .label01, color: .gray4)
    }
    
    private let divider = UIView(backgroundColor: .gray4)
    
    private let createdAtLabel = UILabel().then {
        $0.setText("2024.06.01", style: .label01, color: .gray4)
    }
    
    private let horizontalStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 12
    }
    
    private let metCountLabel = UILabel().then {
        $0.setText("이 모임의 꾸물이들은 ?번 만났어요!", style: .body03, color: .gray8)
        $0.setHighlightText("?번", style: .body03, color: .maincolor)
    }
    
    private let backgroundImageView = UIImageView().then {
        $0.image = .imgMeetingInfoBanner
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
    }
    
    override func setupView() {
        backgroundColor = .lightGreen
        layer.cornerRadius = 8
        
        horizontalStackView.addArrangedSubviews(explanationLabel, divider, createdAtLabel)
        backgroundImageView.addSubviews(horizontalStackView, metCountLabel)
        addSubviews(backgroundImageView)
    }
    
    override func setupAutoLayout() {
        divider.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        metCountLabel.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom).offset(2)
            $0.leading.equalTo(horizontalStackView)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MeetingInfoBannerView {
    func configure(createdAt: String, metCount: Int) {
        createdAtLabel.updateText(createdAt)
        
        metCountLabel.do {
            $0.updateText("이 모임의 꾸물이들은 \(metCount)번 만났어요!")
            $0.setHighlightText("\(metCount)번", style: .body03, color: .maincolor)
        }
    }
}
