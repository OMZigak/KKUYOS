//
//  EnterReadyInfoButtonView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class EnterReadyInfoButtonView: BaseView {
    
    
    // MARK: Property

    private let descriptionLabel: UILabel = UILabel().then {
        $0.setText("준비 정보 입력하기", style: .body03)
    }
    
    private let chevronButton: UIButton = UIButton().then {
        $0.setImage(.iconRight, for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    override func setupView() {
        backgroundColor = .white
        addSubviews(descriptionLabel, chevronButton)
    }
    
    override func setupAutoLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        chevronButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    // TODO: 빼야됨
    
    private func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapped() {
        
    }
}
