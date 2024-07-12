//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

class MyPageViewController: BaseViewController {
    
    private let navigationView = MyPageNavigationView()
    private let myPageContentView = MyPageContentView()
    private let alarmSettingView = AlarmSettingView()
    private let etcSettingView = EtcSettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        view.backgroundColor = .green1

        view.addSubviews(navigationView, myPageContentView, alarmSettingView, etcSettingView)
    }
    
    private func setupAutoLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(96)
        }
        
        myPageContentView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        alarmSettingView.snp.makeConstraints {
            $0.top.equalTo(myPageContentView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(120)
        }
        
        etcSettingView.snp.makeConstraints {
            $0.top.equalTo(alarmSettingView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
