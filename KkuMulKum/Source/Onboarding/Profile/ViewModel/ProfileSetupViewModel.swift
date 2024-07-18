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
    private var compressedImageData: Data?
    
    init(nickname: String, authService: AuthServiceType = AuthService()) {
        self.nickname = nickname
        self.authService = authService
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage.value = image
        if let image = image {
            compressImage(image, maxSizeInBytes: 2 * 1024 * 1024)  // 2MB로 변경
        } else {
            compressedImageData = nil
        }
        isConfirmButtonEnabled.value = compressedImageData != nil
    }
    
    func uploadProfileImage(completion: @escaping (Bool) -> Void) {
        print("uploadProfileImage 함수 호출됨")
        guard let compressedImageData = compressedImageData else {
            print("압축된 이미지 데이터가 없습니다.")
            serverResponse.value = "이미지 데이터가 없습니다."
            completion(false)
            return
        }
        
        print("업로드할 이미지 데이터 크기: \(compressedImageData.count) bytes")
        
        let fileName = "profile_image.jpg"
        let mimeType = "image/jpeg"
        
        authService.performRequest(
            .updateProfileImage(
                image: compressedImageData,
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

    private func compressImage(_ image: UIImage, maxSizeInBytes: Int) {
        guard let originalImageData = image.jpegData(compressionQuality: 1.0) else {
            print("원본 이미지 데이터를 생성할 수 없습니다.")
            return
        }
        
        print("원본 이미지 크기: \(originalImageData.count) bytes")
        
        if originalImageData.count <= maxSizeInBytes {
            print("원본 이미지가 이미 \(maxSizeInBytes) bytes 이하입니다. 압축이 필요하지 않습니다.")
            compressedImageData = originalImageData
            return
        }
        
        var compression: CGFloat = 1.0
        var imageData = originalImageData
        var bestImageData = originalImageData
        var iterationCount = 0
        
        while compression > 0.01 {
            if let compressedData = image.jpegData(compressionQuality: compression) {
                imageData = compressedData
                iterationCount += 1
                print("압축 시도 #\(iterationCount): 크기 \(imageData.count) bytes (압축률: \(compression))")
                
                if imageData.count <= maxSizeInBytes {
                    bestImageData = imageData
                    break
                } else if imageData.count < bestImageData.count {
                    bestImageData = imageData
                }
            }
            compression -= 0.1
        }
        
        compressedImageData = bestImageData
        print("최종 압축 결과: \(bestImageData.count) bytes (원본 대비 \(Int((Double(bestImageData.count) / Double(originalImageData.count)) * 100))% 크기)")
    }
}
