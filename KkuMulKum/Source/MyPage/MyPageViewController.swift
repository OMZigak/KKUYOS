//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCustomNavigationBar()
    }
    
    private func setupCustomNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        // 네비게이션 바의 배경색 설정
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .white
        
        // 타이틀 레이블
        let titleLabel = UILabel()
        titleLabel.text = "마이페이지"
        titleLabel.font = UIFont.pretendard(.body03)
        titleLabel.textAlignment = .center
        
        // 구분선 뷰
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.gray2
        
        navigationBar.addSubview(titleLabel)
        navigationBar.addSubview(separatorView)
        
        // 레이블 제약 조건
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
        
        // 구분선 제약 조건
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
    }
}


