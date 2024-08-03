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
    
    private let authService: AuthServiceType
    private var imageData: Data?
    private let maxImageSizeBytes = 4 * 1024 * 1024

    init(nickname: String, authService: AuthServiceType = AuthService()) {
        self.nickname = nickname
        self.authService = authService
    }
    
    func updateProfileImage(_ image: UIImage?) {
        guard let image = image else {
            profileImage.value = nil
            imageData = nil
            isConfirmButtonEnabled.value = false
            return
        }
        guard let compressedData = compressImage(image, maxSizeInBytes: maxImageSizeBytes) else {
            imageData = nil
            profileImage.value = nil
            isConfirmButtonEnabled.value = false
            print("이미지 압축 실패")
            return
        }
        imageData = compressedData
        profileImage.value = UIImage(data: compressedData)
        print("압축된 이미지 크기: \(compressedData.count) bytes")
        isConfirmButtonEnabled.value = true
    }

    
    private func compressImage(_ image: UIImage, maxSizeInBytes: Int) -> Data? {
        let resizedImage = image.kf.resize(to: image.size, for: .aspectFit)
        
        guard let data = resizedImage.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        if data.count <= maxSizeInBytes {
            return data
        }
        var quality: CGFloat = 0.8
        
        while data.count > maxSizeInBytes && quality > 0.1 {
            quality -= 0.1
            guard let reducedData = resizedImage.jpegData(compressionQuality: quality) else {
                continue
            }
            if reducedData.count <= maxSizeInBytes {
                return reducedData
            }
        }
        
        var newSize = image.size
        while data.count > maxSizeInBytes {
            newSize = CGSize(width: newSize.width * 0.9, height: newSize.height * 0.9)
            let reducedImage = image.kf.resize(to: newSize, for: .aspectFit)
            if let reducedData = reducedImage.jpegData(compressionQuality: quality) {
                if reducedData.count <= maxSizeInBytes {
                    return reducedData
                }
            }
        }
        return nil
    }
    
    func uploadProfileImage(completion: @escaping (Bool) -> Void) {
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
            DispatchQueue.main.async {
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
}
