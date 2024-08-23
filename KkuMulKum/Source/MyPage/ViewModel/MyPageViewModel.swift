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
    private let userService: MyPageUserServiceType
    private let disposeBag = DisposeBag()
    
    let editButtonTapped = PublishRelay<Void>()
    let logoutButtonTapped = PublishRelay<Void>()
    let unsubscribeButtonTapped = PublishRelay<Void>()
    let actionSheetButtonTapped = PublishRelay<ActionSheetKind>()
    
    let pushEditProfileVC: Signal<Void>
    let showActionSheet: Signal<ActionSheetKind>
    let performLogout: Signal<Void>
    let performUnsubscribe: Signal<Void>
    let userInfo: BehaviorRelay<LoginUserModel?>
    
    init(userService: MyPageUserServiceType = MyPageUserService()) {
        self.userService = userService
        self.userInfo = BehaviorRelay<LoginUserModel?>(value: nil)
        
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
    
    func fetchUserInfo() {
        Task {
            do {
                let info = try await userService.getUserInfo()
                userInfo.accept(info)
            } catch {
                print("Failed to fetch user info: \(error)")
            }
        }
    }
    
    func logout() {
        print("로그아웃 눌름 ㅂㅂ")
    }
    
    func unsubscribe() {
        print("탈퇴 누름 ㅂㅂ")
    }
}
