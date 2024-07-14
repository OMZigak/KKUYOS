//
//  FinishCreateViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class FinishCreateViewController: BaseViewController {
    private let peopleImageView: UIImageView = UIImageView().then {
        $0.image = .imgCreateGroup
        $0.contentMode = .scaleAspectFit
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임이 생성되었어요!", style: .head01, color: .gray8)
    }
    
    private let subTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 내에서 약속과 인원을\n추가해보세요", style: .body06, color: .gray6)
    }
    
    private let confirmButton: CustomButton = CustomButton(title: "확인", isEnabled: true).then {
        $0.backgroundColor = .maincolor
    }
    
    override func setupView() {
        view.backgroundColor = .green1
        
        setupNavigationBar(with: "내 모임 추가하기")
        
        view.addSubviews(
            peopleImageView,
            mainTitleLabel,
            subTitleLabel,
            confirmButton
        )
        
        peopleImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(184)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(127))
            $0.width.equalTo(Screen.width(241))
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(peopleImageView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Screen.height(64))
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.width.equalTo(CustomButton.defaultWidth)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupAction() {
        confirmButton.addTarget(
            self,
            action: #selector(presentMeetingInfoViewControllerDidTapped),
            for: .touchUpInside
        )
    }
    
    @objc func presentMeetingInfoViewControllerDidTapped() {
        // TODO: 모임 상세 화면 띄우기
    }
}
