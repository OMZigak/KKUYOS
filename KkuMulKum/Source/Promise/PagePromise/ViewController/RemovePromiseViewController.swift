//
//  RemovePromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/19/24.
//

import UIKit

class RemovePromiseViewController: BaseViewController {
    lazy var exitButton: UIButton = UIButton().then {
        $0.setTitle("약속 나가기", style: .body05, color: .white)
        $0.backgroundColor = .gray7
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    lazy var deleteButton: UIButton = UIButton().then {
        $0.setTitle("약속 삭제하기", style: .body05, color: .mainred)
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = Screen.height(8)
    }
    
    private let promiseNameLabel: UILabel = UILabel().then {
        $0.setText("약속 이름", style: .body03, color: .gray8)
    }
    
    
    // MARK: - LifeCycle
    
    init(promiseName: String) {
        promiseNameLabel.text = promiseName
        
        super.init(nibName: nil, bundle: nil)
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
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(52))
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(52))
        }
    }
}
