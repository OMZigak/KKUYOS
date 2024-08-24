//
//  MeetingInfoMoreViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 8/23/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

protocol MeetingInfoMoreDelegate: AnyObject {
    func exitButtonDidTap()
}

final class MeetingInfoMoreViewController: BaseViewController {
    private let nameLabel = UILabel()
    
    private let exitButton = UIButton().then {
        $0.setTitle("모임 나가기", style: .body05, color: .gray8)
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", style: .body05, color: .white)
        $0.backgroundColor = .gray7
        $0.layer.cornerRadius = 8
    }
    
    
    // MARK: - Property
    
    weak var delegate: MeetingInfoMoreDelegate?
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - LifeCycle
    
    init(meetingName: String) {
        nameLabel.setText(meetingName, style: .body03, color: .gray8)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        view.addSubviews(nameLabel, exitButton, cancelButton)
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(52))
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(Screen.height(52))
        }
    }
    
    override func setupAction() {
        exitButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: false) {
                    owner.delegate?.exitButtonDidTap()
                }
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

