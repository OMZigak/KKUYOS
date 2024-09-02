//
//  ReadyPlanInfoView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class ReadyPlanInfoView: BaseView {
    
    
    // MARK: Property

    let readyTimeLabel: UILabel = UILabel().then {
        $0.setText("12시 30분에 준비하고,\n1시에 이동을 시작해야 해요", style: .body03)
        $0.setHighlightText("12시 30분", "1시", style: .body03, color: .maincolor)
    }
    
    let requestReadyTimeLabel: UILabel = UILabel().then {
        $0.setText("준비 소요 시간: 30분", style: .label02, color: .gray8)
    }
    
    let requestMoveTimeLabel: UILabel = UILabel().then {
        $0.setText("이동 소요 시간: 1시간 30분", style: .label02, color: .gray8)
    }
    
    let editButton: UIButton = UIButton().then {
        $0.setTitle("수정", style: .caption01, color: .gray6)
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = Screen.height(28) / 2
        $0.clipsToBounds = true
    }
    
    
    // MARK: - Setup

    override func setupView() {
        backgroundColor = .white
        
        addSubviews(
            readyTimeLabel,
            requestReadyTimeLabel,
            requestMoveTimeLabel,
            editButton
        )
    }
    
    override func setupAutoLayout() {
        readyTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        requestReadyTimeLabel.snp.makeConstraints {
            $0.top.equalTo(readyTimeLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        requestMoveTimeLabel.snp.makeConstraints {
            $0.top.equalTo(requestReadyTimeLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(18)
            $0.width.equalTo(Screen.width(60))
            $0.height.equalTo(Screen.height(28))
        }
    }
}
