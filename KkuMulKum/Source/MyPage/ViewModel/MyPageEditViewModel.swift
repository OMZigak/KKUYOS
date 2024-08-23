//
//  MyPageEditViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import Moya

class MyPageEditViewModel: ViewModelType {
    private let authService: AuthServiceType
    
    struct Input {
        let profileImageTap: Observable<Void>
        let confirmButtonTap: Observable<Void>
        let newProfileImage: Observable<UIImage?>
    }
    
    struct Output {
        let profileImage: Driver<UIImage?>
        let isConfirmButtonEnabled: Driver<Bool>
        let serverResponse: Driver<String?>
    }
    
    init(authService: AuthServiceType) {
           self.authService = authService
       }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
            let imageDataRelay = BehaviorRelay<Data?>(value: nil)
            let serverResponseRelay = PublishRelay<String?>()
            
        
        input.newProfileImage
            .compactMap { $0?.jpegData(compressionQuality: 1.0) }
            .bind(to: imageDataRelay)
            .disposed(by: DisposeBag())
        
        let profileImage = imageDataRelay
            .map { data -> UIImage? in
                guard let data = data else { return UIImage.imgProfile }
                return UIImage(data: data)
            }
            .asDriver(onErrorJustReturn: UIImage.imgProfile)
        
        let isConfirmButtonEnabled = imageDataRelay
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
        
        
        // TODO: api 연결시 다시 연결예정
//        input.confirmButtonTap
//                   .withLatestFrom(imageDataRelay)
//                   .flatMapLatest { [weak self] imageData -> Observable<String> in
//                       guard let self = self, let imageData = imageData else {
//                           return .just("이미지 데이터가 없습니다.")
//                       }
//                       return self.authService.rx.request(.updateProfileImage(image: imageData, fileName: "profile_image.jpg", mimeType: "image/jpeg"))
//                           .filterSuccessfulStatusCodes()
//                           .map { _ in "프로필 이미지가 성공적으로 업로드되었습니다." }
//                           .catchError { error in
//                               let networkError = error as? NetworkError ?? .unknownError("알 수 없는 오류가 발생했습니다.")
//                               return .just(self.handleError(networkError))
//                           }
//                   }
//                   .bind(to: serverResponseRelay)
//                   .disposed(by: disposeBag)
        
        return Output(
            profileImage: profileImage,
            isConfirmButtonEnabled: isConfirmButtonEnabled,
            serverResponse: serverResponseRelay.asDriver(onErrorJustReturn: nil)
        )
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


