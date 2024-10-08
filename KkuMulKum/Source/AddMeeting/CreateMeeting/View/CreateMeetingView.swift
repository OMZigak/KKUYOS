//
//  CreateMeetingView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateMeetingView: BaseView {
    
    
    // MARK: Property
    
    let nameTextField: CustomTextField = CustomTextField(
        placeHolder: "모임 이름을 입력해 주세요"
    )
    
    let characterLabel: UILabel = UILabel().then {
        $0.setText("0/10", style: .body06, color: .gray3)
    }
    
    let presentButton: CustomButton = CustomButton(
        title: "다음",
        isEnabled: false
    )
    
    let errorLabel: UILabel = UILabel().then {
        $0.setText("한글, 영문, 숫자만을 사용해 총 10자 이내로 입력해주세요. (공백 포함)", style: .caption02, color: .mainred)
        $0.isHidden = true
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 이름을\n입력해 주세요", style: .head01)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        addSubviews(
            mainTitleLabel,
            nameTextField,
            characterLabel,
            errorLabel,
            presentButton
        )
    }
    
    override func setupAutoLayout() {
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            $0.width.equalTo(CustomTextField.defaultWidth)
            $0.height.equalTo(CustomTextField.defaultHeight)
            $0.leading.equalTo(mainTitleLabel)
        }
        
        characterLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameTextField)
            $0.trailing.equalTo(nameTextField.snp.trailing).inset(12)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(nameTextField)
        }
        
        presentButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(Screen.height(50))
        }
    }
}
