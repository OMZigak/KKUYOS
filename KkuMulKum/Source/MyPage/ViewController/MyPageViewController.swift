//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import RxSwift
import RxCocoa

class MyPageViewController: BaseViewController, CustomActionSheetDelegate {
    private let rootView = MyPageView()
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green1
        
        bindViewModel()
        viewModel.fetchUserInfo()
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBarTitle(with: "마이페이지")
    }
    
    private func bindViewModel() {
        // Inputs
        rootView.contentView.editButton.rx.tap
            .bind(to: viewModel.editButtonTapped)
            .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.logoutRow)
            .bind(to: viewModel.logoutButtonTapped)
            .disposed(by: disposeBag)
        
        bindRowTapGesture(for: rootView.etcSettingView.unsubscribeRow)
            .bind(to: viewModel.unsubscribeButtonTapped)
            .disposed(by: disposeBag)
        // Other rows
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
        
        viewModel.userInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userInfo in
                self?.updateUI(with: userInfo)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with userInfo: LoginUserModel?) {
        guard let userInfo = userInfo else { return }
        
        rootView.contentView.nameLabel.text = userInfo.name ?? "꾸물리안 님"
        rootView.contentView.levelLabel.setText("Lv. \(userInfo.level) 지각대장 꾸물이", style: .body05, color: .white)
        rootView.contentView.levelLabel.setHighlightText("Lv. \(userInfo.level)", style: .body05, color: .lightGreen)
        
        if let profileImageURL = userInfo.profileImageURL {
            loadImage(from: profileImageURL, into: rootView.contentView.profileImageView)
        } else {
            rootView.contentView.profileImageView.image = UIImage.imgProfile
        }
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {

    }
    
    private func bindRowTapGesture(for view: UIView) -> Observable<Void> {
        return view.gestureRecognizers?
            .compactMap { $0 as? UITapGestureRecognizer }
            .first?
            .rx.event
            .map { _ in }

        ?? Observable.empty()
    }
    
    private func pushEditProfileViewController() {
        let authService = AuthService()
        let editProfileViewModel = MyPageEditViewModel(authService: authService)
        let editProfileViewController = MyPageEditViewController(viewModel: editProfileViewModel)
        
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    private func pushAskViewController() {
        let askViewController = MyPageAskViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(askViewController, animated: true)
    }
    
    private func pushTermsViewController() {
        let askViewController = MyPageTermsViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(askViewController, animated: true)
    }
    
    func actionButtonDidTap(for kind: ActionSheetKind) {
        viewModel.actionSheetButtonTapped.accept(kind)
    }
    
    private func showActionSheet(for kind: ActionSheetKind) {
        let actionSheet = CustomActionSheetController(kind: kind)
        actionSheet.delegate = self
        present(actionSheet, animated: true, completion: nil)
    }
}
