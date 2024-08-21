//
//  MyPageViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import RxSwift
import RxCocoa

class MyPageViewController: BaseViewController {
    private let rootView = MyPageView()
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBarTitle(with: "마이페이지")
    }
    
    private func bindViewModel() {
        rootView.contentView.editButton.rx.tap
            .bind(to: viewModel.editButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.pushEditProfileVC
            .emit(onNext: { [weak self] in
                self?.pushEditProfileViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func pushEditProfileViewController() {
        let editProfileViewController = MyPageEditViewController()
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
