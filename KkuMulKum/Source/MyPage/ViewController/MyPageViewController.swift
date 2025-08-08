//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit
import SwiftUI

import RxSwift
import RxCocoa
import Kingfisher
import Amplitude

class MyPageViewController: BaseViewController, CustomActionSheetDelegate {
    private let rootView = MyPageView()
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    private var needsUserInfoRefresh = true
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needsUserInfoRefresh {
            viewModel.fetchUserInfo()
            needsUserInfoRefresh = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green1
        
        // Setup SwiftUI content view
        rootView.setupSwiftUIContent(with: viewModel)
        if let hostingController = rootView.contentHostingController {
            addChild(hostingController)
            hostingController.didMove(toParent: self)
        }
        
        Amplitude.instance().logEvent("test_event_from_app")
            print("📤 테스트 이벤트 전송 완료")
        bindViewModel()
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBarTitle(with: "마이페이지")
    }
    
    private func bindViewModel() {
        // Inputs
        // Edit button is now handled by SwiftUI view directly
        // rootView.contentView.editButton.rx.tap
        //     .bind(to: viewModel.editButtonTapped)
        //     .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.logoutRow)
            .bind(to: viewModel.logoutButtonTapped)
            .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.unsubscribeRow)
            .bind(to: viewModel.unsubscribeButtonTapped)
            .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.versionInfoRow)
            .subscribe(onNext: { print("버전정보 탭됨") })
            .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.termsOfServiceRow)
            .subscribe(onNext: { [weak self] in
                self?.pushTermsViewController() })
            .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.inquiryRow)
            .subscribe(onNext: { [weak self] in
                self?.pushAskViewController() })
            .disposed(by: disposeBag)
        
        // Outputs
        viewModel.pushEditProfileVC
            .emit(onNext: { [weak self] in
                self?.pushEditProfileViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.showActionSheet
            .emit(onNext: { [weak self] kind in
                self?.showActionSheet(for: kind)
            })
            .disposed(by: disposeBag)
        
        viewModel.performLogout
            .emit(onNext: { [weak self] in
                self?.viewModel.logout()
            })
            .disposed(by: disposeBag)
        
        viewModel.performUnsubscribe
            .emit(onNext: { [weak self] in
                self?.viewModel.unsubscribe()
            })
            .disposed(by: disposeBag)
        
        viewModel.unsubscribeResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    print("success")
                    self?.navigateToLoginScreen()
                case .failure(let error):
                    print("fauile")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.logoutResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    print("Logout successful")
                    self?.navigateToLoginScreen()
                case .failure(let error):
                    print("Logout failed: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
        // UI updates are now handled by SwiftUI view directly through @ObservedObject
        // viewModel.userInfo
        //     .observe(on: MainScheduler.instance)
        //     .subscribe(onNext: { [weak self] userInfo in
        //         self?.updateUI(with: userInfo)
        //     })
        //     .disposed(by: disposeBag)
    }
    
    // These methods are no longer needed as UI updates are handled by SwiftUI view
    // Keeping them commented for reference in case needed for future migration
    
    /*
    private func updateUI(with userInfo: LoginUserModel?) {
        // UI updates now handled by SwiftUI MyPageContentSwiftUIView
    }
    
    private func updateProfileImage(with urlString: String?, localImage: UIImage? = nil) {
        // Profile image updates now handled by SwiftUI MyPageContentSwiftUIView
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        // Image loading now handled by SwiftUI MyPageContentSwiftUIView
    }
    */
    
    private func bindRowTapGesture(for view: UIView) -> Observable<Void> {
        return view.gestureRecognizers?
            .compactMap { $0 as? UITapGestureRecognizer }
            .first?
            .rx.event
            .map { _ in }
        ?? Observable.empty()
    }
    
    private func pushEditProfileViewController() {
        let editViewModel = MyPageEditViewModel(authService: AuthService())
        let editVC = MyPageEditViewController(viewModel: editViewModel)
        
        editViewModel.profileImageUpdated
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageDataString in
                // Profile image update is now handled by SwiftUI view
                self?.needsUserInfoRefresh = true
            })
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func pushAskViewController() {
        let askViewController = MyPageAskViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(askViewController, animated: true)
    }
    
    private func pushTermsViewController() {
        let askViewController = MyPageTermsViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(askViewController, animated: true)
    }
    
    private func navigateToLoginScreen() {
        let loginViewModel = LoginViewModel()
        loginViewModel.logout()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func actionButtonDidTap(for kind: ActionSheetKind) {
        viewModel.actionSheetButtonTapped.accept(kind)
    }
    
    private func showActionSheet(for kind: ActionSheetKind) {
        let actionSheet = CustomActionSheetController(kind: kind)
        actionSheet.delegate = self
        
        if let tabBarController = self.tabBarController {
            tabBarController.present(actionSheet, animated: true, completion: nil)
        }
    }
}
