//
//  GroupListViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import SnapKit

class GroupListViewController: BaseViewController {
    private lazy var button: CustomButton = CustomButton(title: "모임 추가하기", isEnabled: true).then {
        $0.addTarget(self, action: #selector(didAddScheduleButtonTapped), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.top.equalToSuperview().offset(206)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func didAddScheduleButtonTapped() {
        let scheduleViewController = PromiseViewController()
        
        self.navigationController?.pushViewController(scheduleViewController, animated: true)
    }
}
