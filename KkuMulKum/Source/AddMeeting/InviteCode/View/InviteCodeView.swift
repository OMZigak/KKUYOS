//
//  InviteCodeView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class InviteCodeView: BaseView {
    
    
    // MARK: Property
    
    let inviteCodeTextField: CustomTextField = CustomTextField(
        placeHolder: "모임 초대 코드를 입력해 주세요"
    )
    
    let checkImageView: UIImageView = UIImageView().then {
        $0.image = .iconCheck
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    let errorLabel: UILabel = UILabel().then {
        $0.setText("모임 초대 코드를 다시 확인해주세요.", style: .caption02, color: .mainred)
        $0.isHidden = true
    }
    
    let presentButton: CustomButton = CustomButton(title: "모임 가입하기", isEnabled: false)
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 초대 코드를\n입력해 주세요", style: .head01)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        backgroundColor = .white
        
        addSubviews(
            mainTitleLabel,
            inviteCodeTextField,
            checkImageView,
            errorLabel,
            presentButton
        )
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
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(inviteCodeTextField)
            $0.trailing.equalTo(inviteCodeTextField.snp.trailing).inset(12)
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(checkImageView.snp.height)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(inviteCodeTextField.snp.bottom).offset(8)
            $0.leading.equalTo(inviteCodeTextField)
        }
        
        presentButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(Screen.height(50))
        }
    }
}
