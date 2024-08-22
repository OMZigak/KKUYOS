//
//  MyPageTermsViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import UIKit
import WebKit

class MyPageTermsViewController: UIViewController, WKUIDelegate {
    
    private let viewModel : MyPageViewModel
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
        
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
