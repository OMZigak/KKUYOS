//
//  ProfileViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class ProfileSetupViewModel {
    let profileImage = ObservablePattern<UIImage?>(UIImage.imgProfile)
    let isConfirmButtonEnabled = ObservablePattern<Bool>(false)
    let nickname: String
    let serverResponse = ObservablePattern<String?>(nil)
    
    private let authService: AuthServiceType
    private var imageData: Data?
    
    init(nickname: String, authService: AuthServiceType = AuthService()) {
        self.nickname = nickname
        self.authService = authService
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage.value = image
        if let image = image, let data = image.jpegData(compressionQuality: 1.0) {
            imageData = data
            print("이미지 크기: \(data.count) bytes")
        } else {
            imageData = nil
        }
        isConfirmButtonEnabled.value = imageData != nil
    }
    
    func uploadProfileImage(completion: @escaping (Bool) -> Void) {
        print("uploadProfileImage 함수 호출됨")
        guard let imageData = imageData else {
            print("이미지 데이터가 없습니다.")
            serverResponse.value = "이미지 데이터가 없습니다."
            completion(false)
            return
        }
        
        print("업로드할 이미지 데이터 크기: \(imageData.count) bytes")
        
        let fileName = "profile_image.jpg"
        let mimeType = "image/jpeg"
        
        authService.performRequest(
            .updateProfileImage(
                image: imageData,
                fileName: fileName,
                mimeType: mimeType
            )
        ) { [weak self] (result: Result<EmptyModel, NetworkError>) in
            print("네트워크 요청 완료")
            switch result {
            case .success(_):
                self?.serverResponse.value = "프로필 이미지가 성공적으로 업로드되었습니다."
                print("프로필 이미지 업로드 성공")
                completion(true)
            case .failure(let error):
                self?.handleError(error)
                completion(false)
            }
        }
    }
    
    private func handleError(_ error: NetworkError) {
        serverResponse.value = error.message
        print("프로필 이미지 업로드 실패: \(error.message)")
    }
}
