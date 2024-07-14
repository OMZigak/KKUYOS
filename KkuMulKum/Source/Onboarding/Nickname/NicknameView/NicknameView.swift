//
//  NicknameView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class NicknameView: BaseView {
    let subtitleLabel = UILabel().then {
        $0.setText("이름을 설정해 주세요", style: .head01, color: .gray8)
    }
    
    let nicknameTextField = CustomTextField(placeHolder: "이름을 입력해 주세요").then {
        $0.setLayer(borderWidth: 1, borderColor: .gray3, cornerRadius: 8)
    }
    
    let characterCountLabel = UILabel().then {
        $0.setText("0/5", style: .body06, color: .gray)
        $0.textAlignment = .right
    }
    
    let errorLabel = UILabel().then {
        $0.setText("한글, 영문, 숫자만을 사용해 총 5자 이내로 입력해주세요.", style: .caption02, color: .red)
        $0.isHidden = true
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", style: .body01, color: .white)
        $0.backgroundColor = .gray2
        $0.setLayer(borderWidth: 0, borderColor: .clear, cornerRadius: 8)
        $0.isEnabled = false
    }
    
    override func setupView() {
        backgroundColor = .white
        addSubviews(subtitleLabel, nicknameTextField, errorLabel, nextButton)
        nicknameTextField.addSubview(characterCountLabel)
    }
    
    override func setupAutoLayout() {
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(CustomTextField.defaultHeight)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(Screen.width(30))
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(Screen.height(52))
        }
    }
}
