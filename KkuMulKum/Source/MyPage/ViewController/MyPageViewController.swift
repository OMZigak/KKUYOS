//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class MyPageViewController: BaseViewController, CustomActionSheetDelegate {
    private let rootView = MyPageView()
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserInfo()
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
        
        updateProfileImage(with: userInfo.profileImageURL)
    }
    
    private func updateProfileImage(with urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            rootView.contentView.profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage.imgProfile,
                options: [
                    .transition(.fade(0.2)),
                    .forceRefresh,
                    .cacheOriginalImage
                ],
                completionHandler: { result in
                    switch result {
                    case .success(_):
                        print("Profile image loaded successfully")
                    case .failure(let error):
                        print("Failed to load profile image: \(error.localizedDescription)")
                        self.rootView.contentView.profileImageView.image = UIImage.imgProfile
                    }
                }
            )
        } else {
            rootView.contentView.profileImageView.image = UIImage.imgProfile
        }
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage.imgProfile,
            options: [
                .transition(.fade(0.2)),
                .forceRefresh,
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success(_):
                    print("Image loaded successfully")
                case .failure(let error):
                    print("Failed to load image: \(error.localizedDescription)")
                    imageView.image = UIImage.imgProfile
                }
            }
        )
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
           
           editProfileViewModel.profileImageUpdated
               .observe(on: MainScheduler.instance)
               .subscribe(onNext: { [weak self] imageDataString in
                   if let imageDataString = imageDataString,
                      let imageData = Data(base64Encoded: imageDataString),
                      let image = UIImage(data: imageData) {
                       self?.rootView.contentView.profileImageView.image = image
                   } else {
                       self?.rootView.contentView.profileImageView.image = UIImage.imgProfile
                   }
                   KingfisherManager.shared.cache.clearMemoryCache()
                   KingfisherManager.shared.cache.clearDiskCache()
               })
               .disposed(by: disposeBag)
           
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
