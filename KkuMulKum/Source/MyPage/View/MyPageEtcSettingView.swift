//
//  MyPageEtcSettingView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class EtcSettingView: BaseView {
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.cornerRadius = 12
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    override func setupView() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        let rows = [
            createRow(title: "버전정보", subtitle: "0.1.0"),
            createRow(title: "이용약관"),
            createRow(title: "로그아웃"),
            createRow(title: "탈퇴하기")
        ]
        
        rows.forEach {
            stackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    override func setupAutoLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createRow(title: String, subtitle: String? = nil) -> UIView {
        let rowView = UIView()
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.pretendard(.body01)
            $0.textColor = .gray7
        }
        rowView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel().then {
                $0.text = subtitle
                $0.font = UIFont.pretendard(.body01)
                $0.textColor = .gray8
            }
            rowView.addSubview(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
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
            print("로그아웃 탭됨")
        case 3:
            print("탈퇴하기 탭됨")
        default:
            break
        }
    }
}
