//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

class MyPageViewController: BaseViewController {
    private let rootView = MyPageView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setupView() {
        view.backgroundColor = .green1
        setupNavigationBarTitle(with: "마이페이지")
    }
}
