//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare

class MyPageViewController: BaseViewController {
    private let rootView = MyPageView()
    
    override func loadView() {
        view = rootView
    }
    
 
    override func setupView() {
           view.backgroundColor = .green1
           setupNavigationBarTitle(with: "마이페이지")
           
           bindViewModel()
       }
       
       private func bindViewModel() {
        
       }
       

       
       private func showAlert(title: String, message: String) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
           present(alertController, animated: true, completion: nil)
       }
    
}
