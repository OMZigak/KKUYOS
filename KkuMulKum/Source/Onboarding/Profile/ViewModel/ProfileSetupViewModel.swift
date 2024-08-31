//
//  ProfileViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import Kingfisher

class ProfileSetupViewModel {
    let profileImage = ObservablePattern<UIImage?>(UIImage.imgProfile)
    let isConfirmButtonEnabled = ObservablePattern<Bool>(false)
    let nickname: String
    let serverResponse = ObservablePattern<String?>(nil)
    
    private let authService: AuthServiceProtocol
    private var imageData: Data?
    private let maxImageSizeBytes = 4 * 1024 * 1024
    
    init(nickname: String, authService: AuthServiceProtocol = AuthService()) {
        self.nickname = nickname
        self.authService = authService
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage.value = image
        if let image = image {
            imageData = compressImage(image)
            print("압축된 이미지 크기: \(imageData?.count ?? 0) bytes")
        } else {
            imageData = nil
        }
        isConfirmButtonEnabled.value = imageData != nil
        clearImageCache()
    }
    
    private func compressImage(_ image: UIImage) -> Data? {
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        
        while (imageData?.count ?? 0) > maxImageSizeBytes && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    func uploadProfileImage() async -> Bool {
        print("uploadProfileImage 함수 호출됨")
        guard let imageData = imageData else {
            print("이미지 데이터가 없습니다.")
            serverResponse.value = "이미지 데이터가 없습니다."
            return false
        }
        
        if imageData.count > maxImageSizeBytes {
            print("이미지 크기가 최대 허용 크기를 초과합니다.")
            serverResponse.value = "이미지 크기가 너무 큽니다. 더 작은 이미지를 선택해주세요."
            return false
        }
        
        print("업로드할 이미지 데이터 크기: \(imageData.count) bytes")
        
        let fileName = "profile_image.jpg"
        let mimeType = "image/jpeg"
        
        do {
            let _: EmptyModel = try await authService.performRequest(
                .updateProfileImage(
                    image: imageData,
                    fileName: fileName,
                    mimeType: mimeType
                )
            )
            serverResponse.value = "프로필 이미지가 성공적으로 업로드되었습니다."
            print("프로필 이미지 업로드 성공")
            
            clearImageCache()
            return true
        } catch {
            handleError(error as? NetworkError ?? .unknownError("알 수 없는 오류가 발생했습니다."))
            return false
        }
    }
    
    private func handleError(_ error: NetworkError) {
        switch error {
        case .apiError(let code, let message):
            if code == 413 {
                serverResponse.value = "이미지 크기가 너무 큽니다. 더 작은 이미지를 선택해주세요."
            } else {
                serverResponse.value = "업로드 실패: \(message)"
            }
        case .networkError(let error):
            serverResponse.value = "네트워크 오류: \(error.localizedDescription)"
        case .decodingError:
            serverResponse.value = "데이터 처리 중 오류가 발생했습니다."
        default:
            serverResponse.value = "알 수 없는 오류가 발생했습니다."
        }
        print("프로필 이미지 업로드 실패: \(error.message)")
    }
    
    private func clearImageCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
}
