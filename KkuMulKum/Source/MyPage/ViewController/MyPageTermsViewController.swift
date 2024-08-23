//
//  MyPageTermsViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import UIKit
import WebKit

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
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://arrow-frog-4b9.notion.site/a66033a3ff4a40bfaa6eff0a5bee737d")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBarTitle(with: "이용약관")
        setupNavigationBarBackButton()
    }
}

extension MyPageTermsViewController: WKUIDelegate {}
