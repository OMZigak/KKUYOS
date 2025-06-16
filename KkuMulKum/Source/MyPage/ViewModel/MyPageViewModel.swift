//
//  MyPageViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/21/24.
//

import Foundation
import AuthenticationServices

import RxSwift
import RxCocoa

class MyPageViewModel: NSObject {
    private let userService: MyPageUserServiceProtocol
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
    let unsubscribeResult = PublishRelay<Result<Void, Error>>()
    let logoutResult = PublishRelay<Result<Void, Error>>()

    
    init(userService: MyPageUserServiceProtocol = MyPageUserService()) {
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
    
    func getLevelText(for level: Int) -> String {
        switch level {
        case 1:
            return "빼꼼 꾸물이"
        case 2:
            return "밍기적 꾸물이"
        case 3:
            return "기적 꾸물이"
        case 4:
            return "꾸물꿈"
        default:
            return "꾸물리안 님"
        }
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
            Task {
                do {
                    try await userService.logout()
                    print("Logout successful")
                    logoutResult.accept(.success(()))
                } catch {
                    print("Logout failed: \(error)")
                    logoutResult.accept(.failure(error))
                }
            }
        }
    
    func unsubscribe() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func performUnsubscribe(with authorizationCode: String) {
        Task {
            do {
                try await userService.unsubscribe(authCode: authorizationCode)
                print("Unsubscribe successful")
                unsubscribeResult.accept(.success(()))
            } catch {
                print("Unsubscribe failed: \(error)")
                unsubscribeResult.accept(.failure(error))
            }
        }
    }
}

extension MyPageViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let authorizationCode = appleIDCredential.authorizationCode,
           let authCodeString = String(data: authorizationCode, encoding: .utf8) {
            performUnsubscribe(with: authCodeString)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        unsubscribeResult.accept(.failure(error))
    }
}
