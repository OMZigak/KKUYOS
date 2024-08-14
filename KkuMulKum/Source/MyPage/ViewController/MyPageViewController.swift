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
           rootView.etcSettingView.kakaoShareTapped.bind { [weak self] _ in
               self?.shareKakaoTemplate()
           }
           rootView.etcSettingView.onWithdrawTapped = { [weak self] in
                      self?.showWithdrawBottomSheet()
                  }
       }
       
       private func shareKakaoTemplate() {
           let templateId = 110759
           
           if ShareApi.isKakaoTalkSharingAvailable() {
               ShareApi.shared.shareCustom(templateId: Int64(templateId)) { [weak self] (sharingResult, error) in
                   if let error = error {
                       print("카카오톡 공유 실패: \(error)")
                       self?.showAlert(title: "공유 실패", message: "카카오톡 공유에 실패했습니다.")
                   }
                   else {
                       print("카카오톡 공유 성공")
                       if let sharingResult = sharingResult {
                           UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                       }
                   }
               }
           }
           else {
               print("카카오톡 미설치")
               self.showAlert(title: "알림", message: "카카오톡이 설치되어 있지 않습니다.")
           }
       }
       
       private func showAlert(title: String, message: String) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
           present(alertController, animated: true, completion: nil)
       }
    
    private func showWithdrawBottomSheet() {
           let contentVC = WithdrawContentViewController()
           let bottomSheetVC = BottomSheetViewController(contentViewController: contentVC, defaultHeight: 300)
           
           self.present(bottomSheetVC, animated: false, completion: nil)
       }
}

class WithdrawContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "정말로 탈퇴하시겠습니까?"
        label.textAlignment = .center
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 여기에 탈퇴 확인 버튼 등 추가 UI 요소를 구현할 수 있습니다.
    }
}
