//
//  ProfileViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//


import UIKit

import RxSwift
import RxCocoa
import Moya

class ProfileSetupViewModel {
    // Inputs
    let updateProfileImageTrigger = PublishSubject<Void>()
    
    // Outputs
    let profileImage = BehaviorRelay<UIImage?>(value: UIImage.imgProfile)
    let isConfirmButtonEnabled = BehaviorRelay<Bool>(value: false)
    let serverResponse = PublishSubject<String?>()
    let uploadSuccess = PublishSubject<Void>()
    
    let nickname: String
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<ProfileTargetType>()
    
    init(nickname: String, authService: AuthServiceType = AuthService()) {
        self.nickname = nickname
        self.authService = authService
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage.value = image
        isConfirmButtonEnabled.value = image != nil
    }
    
    func uploadProfileImage(completion: @escaping (Bool) -> Void) {
        print("uploadProfileImage 함수 호출됨")
        guard let image = profileImage.value,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("이미지 변환 실패")
            serverResponse.value = "이미지 변환 중 오류가 발생했습니다."
            completion(false)
            return
        }
        
        print("이미지 데이터 크기: \(imageData.count) bytes")
        
        let fileName = "profile_image.jpg"
        let mimeType = "image/jpeg"
        
        updateProfileImageTrigger
            .withLatestFrom(profileImage)
            .flatMapLatest { [weak self] image -> Observable<Result<ResponseBodyDTO<EmptyModel>, Error>> in
                guard let self = self, let image = image else { return .empty() }
                return self.uploadProfileImage(image: image)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    if response.success {
                        self?.serverResponse.onNext("프로필 이미지가 성공적으로 업로드되었습니다.")
                        self?.uploadSuccess.onNext(())
                    } else {
                        self?.serverResponse.onNext(response.error?.message ?? "알 수 없는 오류가 발생했습니다.")
                    }
                case .failure(let error):
                    self?.serverResponse.onNext("네트워크 오류: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage.accept(image)
        isConfirmButtonEnabled.accept(image != nil)
    }
    
    func uploadProfileImage() {
        updateProfileImageTrigger.onNext(())
    }
    
    private func uploadProfileImage(image: UIImage) -> Observable<Result<ResponseBodyDTO<EmptyModel>, Error>> {
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                observer.onNext(.failure(NSError(domain: "Image conversion failed", code: 0, userInfo: nil)))
                observer.onCompleted()
                return Disposables.create()
            }
            
            let fileName = "profile_image.jpg"
            let mimeType = "image/jpeg"
            
            self.provider.request(.updateProfileImage(image: imageData, fileName: fileName, mimeType: mimeType)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<EmptyModel>.self, from: response.data)
                        observer.onNext(.success(decodedResponse))
                    } catch {
                        observer.onNext(.failure(error))
                    }
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
