//
//  Nickname.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class NicknameViewController: BaseViewController {
    
    private let nicknameView = NicknameView()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nicknameView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        nicknameView.nextButton.isEnabled = !(textField.text?.isEmpty ?? true)
        nicknameView.nextButton.backgroundColor = nicknameView.nextButton.isEnabled ? .blue : .lightGray
    }
    
    @objc private func nextButtonTapped() {
        // 다음 버튼이 탭되었을 때의 동작
        print("Next button tapped")
    }
}
