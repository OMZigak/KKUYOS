//
//  InvitationCodePopUpView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class InvitationCodePopUpView: BaseView {
    private let contentView = UIView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("친구 초대하기", style: .body01, color: .gray8)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setText(
            "초대 코드를 공유해 함께할 꾸물이를 추가해 보세요",
            style: .caption02,
            color: .gray6
        )
    }
    
    private let innerContentView = UIView(backgroundColor: .gray0).then {
        $0.layer.cornerRadius = 4
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setText("초대코드", style: .body06, color: .gray8)
    }
    
    let invitationCodeLabel = UILabel()
    
    let inviteLaterButton = UIButton(backgroundColor: .gray3).then {
        $0.setTitle("나중에 초대하기", style: .body05, color: .white)
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    let copyButton = UIButton(backgroundColor: .gray7).then {
        $0.setTitle("복사하기", style: .body05, color: .white)
        $0.backgroundColor = .gray7
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    private let buttonStackView = UIStackView(axis: .horizontal).then {
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    override func setupView() {
        backgroundColor = .black.withAlphaComponent(0.7)
        
        innerContentView.addSubviews(descriptionLabel, invitationCodeLabel)
        buttonStackView.addArrangedSubviews(inviteLaterButton, copyButton)
        contentView.addSubviews(titleLabel, subtitleLabel, innerContentView, buttonStackView)
        addSubview(contentView)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        contentView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.width.equalTo(310)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        innerContentView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-35)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
        
        invitationCodeLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(innerContentView.snp.bottom).offset(32)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
}

extension InvitationCodePopUpView {
    var inviteLaterButtonDidTap: Observable<Void> { inviteLaterButton.rx.tap.asObservable() }
    var copyButtonDidTap: Observable<Void> { copyButton.rx.tap.asObservable() }
    
    func isBackgroundViewDidTap(with location: CGPoint) -> Bool {
        return !contentView.frame.contains(location)
    }
    
    func setInvitationCodeText(_ invitationCode: String) {
        invitationCodeLabel.setText(invitationCode, style: .body01, color: .maincolor)
    }
}
