//
//  CreateMeetingView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateMeetingView: BaseView {
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 이름을\n입력해 주세요", style: .head01)
    }
    
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
    
    override func setupView() {
        addSubviews(
            mainTitleLabel,
            nameTextField,
            characterLabel,
            presentButton
        )
    }
    
    override func setupAutoLayout() {
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(24)
            $0.width.equalTo(CustomTextField.defaultWidth)
            $0.height.equalTo(CustomTextField.defaultHeight)
            $0.leading.equalTo(mainTitleLabel)
        }
        
        characterLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameTextField)
            $0.trailing.equalTo(nameTextField.snp.trailing).inset(12)
        }
        
        presentButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(Screen.height(50))
        }
    }
}
