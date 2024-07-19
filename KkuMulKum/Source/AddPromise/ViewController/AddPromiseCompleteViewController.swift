//
//  AddPromiseCompleteViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/17/24.
//

import UIKit

import RxCocoa
import RxSwift

final class AddPromiseCompleteViewController: BaseViewController {
    let promiseID: Int
    
    private let disposeBag = DisposeBag()
    private let rootView = AddPromiseCompleteView()
    
    
    // MARK: - Initializer
    
    init(promiseID: Int) {
        self.promiseID = promiseID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle(with: "내 모임 추가하기")
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupView() {
        view.backgroundColor = .green2
    }
    
    override func setupAction() {
        rootView.confirmButton.rx.tap
            .subscribe(with: self) {
                owner,
                _ in
                // TODO: 약속 상세 화면으로 이동하기
                /// 생성된 약속 ID, 약속 이름 전달
                guard let rootViewController = owner.navigationController?.viewControllers.first as? MainTabBarController else {
                    return
                }
                owner.navigationController?.popToViewController(
                    rootViewController,
                    animated: false
                )
                rootViewController.navigationController?.pushViewController(
                    PagePromiseViewController(
                        promiseViewModel: PagePromiseViewModel(
                            promiseID: self.promiseID,
                            service: PromiseService()
                        )
                    ),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
}
