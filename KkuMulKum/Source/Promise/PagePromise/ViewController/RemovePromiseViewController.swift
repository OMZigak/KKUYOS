//
//  RemovePromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/19/24.
//

import UIKit

class RemovePromiseViewController: BaseViewController {
    let exitButton: CustomButton = CustomButton(title: "약속 나가기").then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray7
    }
    
    let deleteButton: CustomButton = CustomButton(title: "약속 삭제하기").then {
        $0.setTitleColor(.mainred, for: .normal)
        $0.backgroundColor = .gray1
    }
    
    private let promiseNameLabel: UILabel = UILabel().then {
        $0.setText("약속 이름", style: .body03, color: .gray8)
    }
    
    // MARK: - LifeCycle

    init(promiseName: String) {
        promiseNameLabel.text = promiseName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup

    override func setupView() {
        view.addSubviews(
            promiseNameLabel,
            exitButton,
            deleteButton
        )
        
        promiseNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }

        exitButton.snp.makeConstraints {
            $0.top.equalTo(promiseNameLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
