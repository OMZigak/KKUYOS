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
    private let userService: MyPageUserServiceType
    private let userInfo = BehaviorRelay<LoginUserModel?>(value: nil)
    
    struct Input {
        let profileImageTap: Observable<Void>
        let confirmButtonTap: Observable<Void>
        let newProfileImage: Observable<UIImage?>
    }
    
    struct Output {
        let profileImage: Driver<UIImage?>
        let isConfirmButtonEnabled: Driver<Bool>
        let serverResponse: Driver<String?>
        let userInfo: Driver<LoginUserModel?>
    }
    
    init(authService: AuthServiceProtocol, userService: MyPageUserServiceType = MyPageUserService()) {
        self.authService = authService
        self.userService = userService
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let imageDataRelay = BehaviorRelay<Data?>(value: nil)
        let serverResponseRelay = PublishRelay<String?>()
        
        input.newProfileImage
            .compactMap { $0?.jpegData(compressionQuality: 1.0) }
            .bind(to: imageDataRelay)
            .disposed(by: disposeBag)
        
        let profileImage = imageDataRelay
            .map { data -> UIImage? in
                guard let data = data else { return UIImage.imgProfile }
                return UIImage(data: data)
            }
            .asDriver(onErrorJustReturn: UIImage.imgProfile)
        
        let isConfirmButtonEnabled = imageDataRelay
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        input.confirmButtonTap
            .withLatestFrom(imageDataRelay)
            .flatMapLatest { [weak self] imageData -> Observable<String> in
                guard let self = self, let imageData = imageData else {
                    return .just("이미지 데이터가 없습니다.")
                }
                return Observable.create { observer in
                    Task {
                        do {
                            let _: EmptyModel = try await self.authService.performRequest(
                                .updateProfileImage(
                                    image: imageData,
                                    fileName: "profile_image.jpg",
                                    mimeType: "image/jpeg"
                                )
                            )
                            observer.onNext("프로필 이미지가 성공적으로 업로드되었습니다.")
                            observer.onCompleted()
                        } catch {
                            let networkError = error as? NetworkError ?? .unknownError("알 수 없는 오류가 발생했습니다.")
                            observer.onNext(self.handleError(networkError))
                            observer.onCompleted()
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: serverResponseRelay)
            .disposed(by: disposeBag)
        
        return Output(
            profileImage: profileImage,
            isConfirmButtonEnabled: isConfirmButtonEnabled,
            serverResponse: serverResponseRelay.asDriver(onErrorJustReturn: nil),
            userInfo: userInfo.asDriver()
        )
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
        default:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
