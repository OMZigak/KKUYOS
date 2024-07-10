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
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "친구 초대하기"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .gray8
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "초대 코드를 공유해 함께할 꾸물이를 추가해 보세요"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray6
    }
    
    // TODO: gray -> gray0
    private let innerContentView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 4
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "초대코드"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray8
    }
    
    private let invitationCodeLabel = UILabel()
    
    private let inviteLaterButton = UIButton().then {
        $0.setTitle("나중에 초대하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    private let copyButton = UIButton().then {
        $0.setTitle("복사하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray7
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    override func setupView() {
        backgroundColor = .black.withAlphaComponent(0.6)
        
        setupBlurView()
        
        innerContentView.addSubview(descriptionLabel)
        innerContentView.addSubview(invitationCodeLabel)
        buttonStackView.addArrangedSubview(inviteLaterButton)
        buttonStackView.addArrangedSubview(copyButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(innerContentView)
        contentView.addSubview(buttonStackView)
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
}

private extension InvitationCodePopUpView {
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        addSubview(blurView)
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
