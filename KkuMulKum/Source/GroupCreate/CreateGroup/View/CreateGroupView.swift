//
//  CreateGroupView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateGroupView: BaseView {
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 이름을\n입력해 주세요", style: .head01)
    }
    
    private let inviteCodeTextField: CustomTextField = CustomTextField(
        placeHolder: "모임 이름을 입력해 주세요"
    )
    
    let presentButton: CustomButton = CustomButton(title: "다음", isEnabled: false)
}
