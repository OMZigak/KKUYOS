//
//  MyPageViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel {
    
    let editButtonTapped = PublishRelay<Void>()
    let logoutButtonTapped = PublishRelay<Void>()
    let unsubscribeButtonTapped = PublishRelay<Void>()
    let actionSheetButtonTapped = PublishRelay<ActionSheetKind>()
    
    let pushEditProfileVC: Signal<Void>
    let showActionSheet: Signal<ActionSheetKind>
    let performLogout: Signal<Void>
    let performUnsubscribe: Signal<Void>
    private let disposeBag = DisposeBag()
    
    
    init() {
        pushEditProfileVC = editButtonTapped.asSignal()
        
        showActionSheet = Observable.merge(
            logoutButtonTapped.map { ActionSheetKind.logout },
            unsubscribeButtonTapped.map { ActionSheetKind.unsubscribe }
        ).asSignal(onErrorJustReturn: .logout)
        
        let actionSheetResult = actionSheetButtonTapped.asObservable()
        
        performLogout = actionSheetResult
            .filter { $0 == .logout }
            .map { _ in }
            .asSignal(onErrorJustReturn: ())
        
        performUnsubscribe = actionSheetResult
            .filter { $0 == .unsubscribe }
            .map { _ in }
            .asSignal(onErrorJustReturn: ())
    }
    
    func logout() {
        print("로그아웃 눌름 ㅂㅂ")
    }
    
    func unsubscribe() {
        print("탈퇴 누름 ㅂㅂ")
    }
}
