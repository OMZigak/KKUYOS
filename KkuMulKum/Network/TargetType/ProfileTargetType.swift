//
//  ProfileTargetType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/16/24.
//

import Foundation

import Moya

enum ProfileTargetType {
    ///jpg 고정이 아닌 jpg, png, webp 같이 받기위함
    case updateProfileImage(image: Data, fileName: String, mimeType: String)
}

extension ProfileTargetType: TargetType {
    var baseURL: URL {
        guard let privacyInfo = Bundle.main.privacyInfo,
              let urlString = privacyInfo["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist")
        }
        return url
    }
    
    var path: String {
        return "/api/v1/users/me/image"
    }
    
    var method: Moya.Method {
        return .patch
    }
    
    var task: Task {
            switch self {
            case .updateProfileImage(let imageData, let fileName, let mimeType):
                let formData: [MultipartFormData] = [
                    MultipartFormData(
                        provider: .data(imageData),
                        name: "image",
                        fileName: fileName,
                        mimeType: mimeType
                    )
                ]
                return .uploadMultipart(formData)
            }
        }
    
    var headers: [String : String]? {
        guard let token = DefaultKeychainService.shared.accessToken else {
            return ["Content-Type": "multipart/form-data"]
        }
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
    }
}
