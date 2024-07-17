//
//  ProfileViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import Moya
import MobileCoreServices

class ProfileSetupViewModel {
    let profileImage = ObservablePattern<UIImage?>(UIImage.imgProfile)
    let isConfirmButtonEnabled = ObservablePattern<Bool>(false)
    let nickname: String
    let serverResponse = ObservablePattern<String?>(nil)
    
    private let provider = MoyaProvider<ProfileTargetType>()
    
    init(nickname: String) {
        self.nickname = nickname
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
        
        provider.request(.updateProfileImage(image: imageData, fileName: fileName, mimeType: mimeType)) { [weak self] result in
            print("네트워크 요청 완료")
            switch result {
            case .success(let response):
                print("서버 응답 상태 코드: \(response.statusCode)")
                print("서버 응답 데이터: \(String(data: response.data, encoding: .utf8) ?? "디코딩 불가")")
                do {
                    let decodedResponse = try JSONDecoder().decode(
                        ResponseBodyDTO<EmptyModel>.self,
                        from: response.data
                    )
                    if decodedResponse.success {
                        self?.serverResponse.value = "프로필 이미지가 성공적으로 업로드되었습니다."
                        print("프로필 이미지 업로드 성공")
                        completion(true)
                    } else {
                        if let errorCode = decodedResponse.error?.code {
                            switch errorCode {
                            case 40080:
                                self?.serverResponse.value = "이미지 확장자는 jpg, png, webp만 가능합니다."
                            case 40081:
                                self?.serverResponse.value = "이미지 사이즈는 5MB를 넘을 수 없습니다."
                            case 40420:
                                self?.serverResponse.value = "유저를 찾을 수 없습니다."
                            default:
                                self?.serverResponse.value = decodedResponse.error?.message ??
                                "알 수 없는 오류가 발생했습니다."
                            }
                        } else {
                            self?.serverResponse.value = decodedResponse.error?.message ??
                            "알 수 없는 오류가 발생했습니다."
                        }
                        print("프로필 이미지 업로드 실패: \(self?.serverResponse.value ?? "")")
                        completion(false)
                    }
                } catch {
                    self?.serverResponse.value = "데이터 디코딩 중 오류가 발생했습니다."
                    print("데이터 디코딩 오류: \(error)")
                    completion(false)
                }
            case .failure(let error):
                self?.serverResponse.value = "네트워크 오류: \(error.localizedDescription)"
                print("네트워크 오류: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
