//
//  CreateSuccessViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import UIKit

class CreateSuccessViewController: BaseViewController {
    
    
    // MARK: Property
    
    let meetingID: Int

    private let peopleImageView: UIImageView = UIImageView().then {
        $0.image = .imgCreateGroup
        $0.contentMode = .scaleAspectFit
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("모임이 생성되었어요!", style: .head01, color: .gray8)
    }
    
    private let subTitleLabel: UILabel = UILabel().then {
        $0.setText("모임 내에서 약속과 인원을\n추가해보세요", style: .body06, color: .gray6)
    }.then {
        $0.textAlignment = .center
    }
    
    private let confirmButton: CustomButton = CustomButton(title: "확인", isEnabled: true).then {
        $0.backgroundColor = .maincolor
    }
    
    
    // MARK: - LifeCycle
    
    init(meetingID: Int) {
        self.meetingID = meetingID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    
    // MARK: - Setup

    override func setupView() {
        view.backgroundColor = .green1
        
        setupNavigationBarTitle(with: "내 모임 추가하기")
        navigationController?.navigationItem.hidesBackButton = true
        
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
            action: #selector(presentMeetingInfoViewControllerDidTap),
            for: .touchUpInside
        )
    }
}


// MARK: - Extension

private extension CreateSuccessViewController {
    @objc 
    func presentMeetingInfoViewControllerDidTap() {
        let meetingInfoViewController = MeetingInfoViewController(
            viewModel: MeetingInfoViewModel(
                meetingID: self.meetingID,
                service: MeetingService()
            )
        )
        
        guard let rootViewController = navigationController?.viewControllers.first as? MainTabBarController else {
            return
        }
        
        navigationController?.popToViewController(
            rootViewController,
            animated: false
        )
        
        rootViewController.navigationController?.pushViewController(
            meetingInfoViewController,
            animated: true
        )
    }
}
