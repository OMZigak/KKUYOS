//
//  EnterInviteCodeView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class EnterInviteCodeView: BaseView {
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 초대 코드를\n입력해 주세요", style: .head01)
    }
    
    private let inviteCodeTextField: CustomTextField = CustomTextField(
        placeHolder: "모임 초대 코드를 입력해 주세요"
    )
    
    let presentButton: CustomButton = CustomButton(title: "모임 가입하기", isEnabled: false)
    
    override func setupView() {
        addSubviews(mainTitleLabel, inviteCodeTextField, presentButton)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        inviteCodeTextField.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(24)
            $0.width.equalTo(CustomTextField.defaultWidth)
            $0.height.equalTo(CustomTextField.defaultHeight)
            $0.leading.equalTo(mainTitleLabel)
        }
        
        presentButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(Screen.height(50))
        }
    }
}
