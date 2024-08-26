//
//  AddPromiseCompleteView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/17/24.
//

import UIKit

import SnapKit
import Then

final class AddPromiseCompleteView: BaseView {
    private let topBackgroundView = UIView(backgroundColor: .white)
    
    private let progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .maincolor
        $0.backgroundColor = .gray2
        $0.setProgress(1, animated: false)
    }
    
    private let completionImageView = UIImageView(
        image: .imgCompletion.withRenderingMode(.alwaysOriginal)
    ).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("약속이 생성되었어요!", style: .head01, color: .gray8)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setText("해당 약속은 모임 내에서 확인 가능해요", style: .body06, color: .gray6)
    }
    
    let confirmButton = CustomButton(title: "확인", isEnabled: true)
    
    override func setupView() {
        backgroundColor = .green1
        
        addSubviews(
            topBackgroundView,
            progressView,
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
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(-1)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(4))
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
