//
//  MyPageEditViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import UIKit

import RxSwift
import RxCocoa

class MyPageEditViewModel: ViewModelType {
    private let authService: AuthServiceProtocol
    private let userService: MyPageUserServiceProtocol
    private let userInfo = BehaviorRelay<LoginUserModel?>(value: nil)
    let profileImageUpdated = PublishSubject<String?>()
    
    struct Input {
        let confirmButtonTap: Observable<Void>
        let skipButtonTap: Observable<Void>
    }
    
    struct Output {
        let isConfirmButtonEnabled: Driver<Bool>
        let serverResponse: Driver<String?>
        let userInfo: Driver<LoginUserModel?>
    }
    
    init(authService: AuthServiceProtocol, userService: MyPageUserServiceProtocol = MyPageUserService()) {
        self.authService = authService
        self.userService = userService
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let serverResponseRelay = PublishRelay<String?>()
        
        let isConfirmButtonEnabled = BehaviorRelay<Bool>(value: false)
        
        return Output(
            isConfirmButtonEnabled: isConfirmButtonEnabled.asDriver(),
            serverResponse: serverResponseRelay.asDriver(onErrorJustReturn: nil),
            userInfo: userInfo.asDriver()
        )
    }
    
    func updateProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }

        Task {
            do {
                let _: EmptyModel = try await self.authService.performRequest(
                    .updateProfileImage(
                        image: imageData,
                        fileName: "profile_image.jpg",
                        mimeType: "image/jpeg"
                    )
                )
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageUpdated.onNext(imageData.base64EncodedString())
                }
            } catch {
                let networkError = error as? NetworkError ?? .unknownError("오류 발생.")
                print("Profile image upload failed: \(networkError)")
                self.profileImageUpdated.onNext(nil)
            }
        }
    }
    
    func setDefaultProfileImage() {
        Task {
            do {
                let defaultImageData = UIImage.imgProfile.jpegData(compressionQuality: 1.0) ?? Data()
                let _: EmptyModel = try await self.authService.performRequest(
                    .updateProfileImage(
                        image: defaultImageData,
                        fileName: "default_profile.jpg",
                        mimeType: "image/jpeg"
                    )
                )
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageUpdated.onNext(nil)
                }
            } catch {
                let networkError = error as? NetworkError ?? .unknownError("오류 발생.")
                print("Default profile image upload failed: \(networkError)")
                self.profileImageUpdated.onNext(nil)
            }
        }
    }
    
    func fetchUserInfo() {
        Task {
            do {
                let info = try await userService.getUserInfo()
                DispatchQueue.main.async { [weak self] in
                    self?.userInfo.accept(info)
                }
            } catch {
                print("Failed to fetch user info: \(error)")
            }
        }
    }
    
    private func handleError(_ error: NetworkError) -> String {
        switch error {
        case .apiError(let code, let message):
            return code == 413 ? "이미지 크기가 너무 큽니다. 더 작은 이미지를 선택해주세요." : "업로드 실패: \(message)"
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .unknownError(let message):
            return "알 수 없는 오류가 발생했습니다: \(message)"
        case .invalidImageFormat:
            return "잘못된 이미지 형식입니다. 지원되는 형식의 이미지를 선택해주세요."
        case .imageSizeExceeded:
            return "이미지 크기가 허용 한도를 초과했습니다. 더 작은 이미지를 선택해주세요."
        case .userNotFound:
            return "사용자를 찾을 수 없습니다. 로그인 상태를 확인해주세요."
        }
    }
}
