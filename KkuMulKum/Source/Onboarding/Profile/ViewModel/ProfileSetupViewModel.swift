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
    private let maxImageSizeBytes = 5 * 1024 * 1024

    
    init(nickname: String, authService: AuthServiceType = AuthService()) {
        self.nickname = nickname
        self.authService = authService
    }
    
    func updateProfileImage(_ image: UIImage?) {
           if let image = image {
               let compressedImage = compressImage(image)
               profileImage.value = compressedImage
               if let data = compressedImage.jpegData(compressionQuality: 1.0) {
                   imageData = data
                   print("압축된 이미지 크기: \(data.count) bytes")
                   isConfirmButtonEnabled.value = true
               } else {
                   imageData = nil
                   isConfirmButtonEnabled.value = false
                   print("이미지 데이터 변환 실패")
               }
           } else {
               profileImage.value = nil
               imageData = nil
               isConfirmButtonEnabled.value = false
           }
       }
    
    private func compressImage(_ image: UIImage) -> UIImage {
        var compression: CGFloat = 0.9
        var imageData = image.jpegData(compressionQuality: compression)
        
        while (imageData?.count ?? 0) > maxImageSizeBytes && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        if (imageData?.count ?? 0) > maxImageSizeBytes {
            let scale = sqrt(Double(maxImageSizeBytes) / Double(imageData?.count ?? 1))
            let newSize = CGSize(width: image.size.width * CGFloat(scale),
                                 height: image.size.height * CGFloat(scale))
            UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resizedImage ?? image
        }
        
        return UIImage(data: imageData!) ?? image
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
           
           // 추가된 부분: 이미지 크기 검사
           if imageData.count > maxImageSizeBytes {
               print("이미지 크기가 5MB를 초과합니다.")
               serverResponse.value = "이미지 크기가 너무 큽니다. 5MB 이하의 이미지를 선택해주세요."
               completion(false)
               return
           }

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
        serverResponse.value = error.message
        print("프로필 이미지 업로드 실패: \(error.message)")
    }
}
