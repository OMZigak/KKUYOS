//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import SnapKit

class MyPageViewController: BaseViewController {
    private let navigationView = MyPageNavigationView()
    private let myPageContentView = MyPageContentView()
    private let alarmSettingView = AlarmSettingView()
    private let etcSettingView = EtcSettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAutoLayout()
    }
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = .green1
        view.addSubview(navigationView)
        view.addSubview(myPageContentView)
        view.addSubview(alarmSettingView)
        view.addSubview(etcSettingView)
    }
    
    private func setupAutoLayout() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        myPageContentView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        alarmSettingView.snp.makeConstraints {
            $0.top.equalTo(myPageContentView.separatorView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        etcSettingView.snp.makeConstraints { 
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
