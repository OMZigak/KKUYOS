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
    
    let kakaoShareTapped = ObservablePattern<Void?>(nil)
    var onWithdrawTapped: (() -> Void)?
    
    let stackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    override func setupView() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray2.cgColor
        layer.cornerRadius = 8
        
        stackView.addArrangedSubviews(
            createRow(title: "버전정보", subtitle: "1.0.0"),
            createRow(title: "이용약관"),
            createRow(title: "문의하기"),
            createRow(title: "로그아웃"),
            createRow(title: "탈퇴하기")
        )
        
        addSubviews(stackView)
    }
    
    override func setupAutoLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(22)
        }
    }
    
    private func createRow(title: String, subtitle: String? = nil) -> UIView {
        let rowView = UIView()
        let titleLabel = UILabel().then {
            $0.setText(title, style: .body03, color: .gray7)
        }
        rowView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel().then {
                $0.setText(subtitle, style: .body03, color: .gray8)
            }
            rowView.addSubview(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.verticalEdges.equalToSuperview()
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rowTapped(_:)))
        rowView.addGestureRecognizer(tapGesture)
        rowView.isUserInteractionEnabled = true
        
        return rowView
    }
    
    @objc private func rowTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        let index = stackView.arrangedSubviews.firstIndex(of: tappedView)
        
        switch index {
        case 0:
            print("버전정보 탭됨")
        case 1:
            print("이용약관 탭됨") 
        case 2:
            print("문의하기 탭됨")
        case 3:
            print("로그아웃 탭됨")
        case 4:
            onWithdrawTapped?()
        default:
            break
        }
    }
}
