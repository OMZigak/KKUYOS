//
//  NicknameView.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import SnapKit

class NicknameView: UIView {
    
    let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 설정"
        label.font = UIFont.pretendard(.body03)
        label.textAlignment = .center
        return label
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름을 설정해 주세요"
        label.font = UIFont.pretendard(.head01)
        label.textAlignment = .left
        label.textColor = .gray1
        return label
    }()
    
    let nicknameTextField: CustomTextField = {
        let textField = CustomTextField(placeHolder: "text")
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        [navigationBar, titleLabel, separatorLine, subtitleLabel, nicknameTextField, nextButton].forEach { addSubview($0) }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(navigationBar)
            $0.centerX.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(CustomTextField.defaultHeight)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
    }
}
