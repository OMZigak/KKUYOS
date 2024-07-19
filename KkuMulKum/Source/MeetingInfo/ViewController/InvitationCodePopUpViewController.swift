//
//  InvitationCodePopUpViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class InvitationCodePopUpViewController: BaseViewController {
    private let invitationCode: String
    private let disposeBag = DisposeBag()
    let rootView = InvitationCodePopUpView()
    
    
    // MARK: - Initializer
    
    init(invitationCode: String) {
        self.invitationCode = invitationCode
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
        
        rootView.setInvitationCodeText(invitationCode)
    }
    
    override func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    override func setupAction() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self, onNext: { owner, tapGesture in
                let location = tapGesture.location(in: owner.view)
                if owner.rootView.isBackgroundViewDidTap(with: location) {
                    owner.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        rootView.inviteLaterButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        rootView.copyButtonDidTap
            .subscribe(with: self) { owner, _ in
                UIPasteboard.general.string = owner.invitationCode
                
                let toast = Toast()
                toast.show(
                    message: "클립보드에 복사가 완료되었어요!",
                    view: owner.view,
                    position: .bottom,
                    inset: 100
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
