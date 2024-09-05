//
//  MyPageTermsViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import UIKit
import WebKit

import SnapKit

class MyPageTermsViewController: BaseViewController {
    
    private let viewModel: MyPageViewModel
    private var webView: WKWebView!

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = UIView()
        view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle(with: "이용약관")
        setupNavigationBarBackButton()
        
        setupConstraints()
        
        if let myURL = URL(string: "https://arrow-frog-4b9.notion.site/a66033a3ff4a40bfaa6eff0a5bee737d") {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustWebViewContentInset()
    }
    
    private func adjustWebViewContentInset() {
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: view.safeAreaInsets.bottom + (tabBarController?.tabBar.frame.height ?? 0),
            right: 0
        )
        webView.scrollView.contentInset = contentInset
        webView.scrollView.scrollIndicatorInsets = contentInset
    }
}

extension MyPageTermsViewController: WKUIDelegate {}
