//
//  SetReadyInfoCompleted.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/17/24.
//

import UIKit

import SnapKit
import Then

final class SetReadyCompletedView: BaseView {
    private let topBackgroundView = UIView(backgroundColor: .white)
    
    private let completionImageView = UIImageView(image: .imgComplete).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("준비 정보 설정이 완료되었어요!", style: .head01, color: .gray8)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setText("설정하신 시간에 맞춰서\n준비 및 이동 시간에 알림을 울려들리게요", style: .body06, color: .gray6)
    }
    
    let confirmButton = CustomButton(title: "확인", isEnabled: true)
    
    override func setupView() {
        backgroundColor = .green1
        
        addSubviews(
            topBackgroundView,
            completionImageView,
            titleLabel,
            subtitleLabel,
            confirmButton
        )
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeArea.snp.top)
        }
        
        completionImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(172)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Screen.width(172))
            $0.height.equalTo(Screen.height(134))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(completionImageView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.bottom.equalToSuperview().offset(-64)
        }
    }
}
