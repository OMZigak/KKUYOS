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
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    private var needsUserInfoRefresh = true
    private var hostingController: UIHostingController<MyPageSwiftUIView>?
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .green1
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
        
        setupSwiftUIView()
        
        Amplitude.instance().logEvent("test_event_from_app")
            print("📤 테스트 이벤트 전송 완료")
        bindViewModel()
        setupNotificationObservers()
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBarTitle(with: "마이페이지")
    }
    
    private func setupSwiftUIView() {
        let swiftUIView = MyPageSwiftUIView(viewModel: viewModel)
        hostingController = UIHostingController(rootView: swiftUIView)
        
        guard let hostingController = hostingController else { return }
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showTerms),
            name: Notification.Name("ShowTerms"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showAsk),
            name: Notification.Name("ShowAsk"),
            object: nil
        )
    }
    
    @objc private func showTerms() {
        pushTermsViewController()
    }
    
    @objc private func showAsk() {
        pushAskViewController()
    }
    
    private func bindViewModel() {
        // ViewModel bindings are now handled by SwiftUI views
        
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
