//
//  AuthTargetType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/18/24.
//

import Foundation

import Moya

enum AuthTargetType {
    case appleLogin(identityToken: String, fcmToken: String)
    case kakaoLogin(accessToken: String, fcmToken: String)
    case refreshToken(refreshToken: String)
    case updateProfileImage(image: Data, fileName: String, mimeType: String)
    case updateName(name: String)
}

extension AuthTargetType: TargetType {
    var baseURL: URL {
        guard let privacyInfo = Bundle.main.privacyInfo,
              let urlString = privacyInfo["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .appleLogin, .kakaoLogin:
            return "/api/v1/auth/signin"
        case .refreshToken:
            return "/api/v1/auth/reissue"
        case .updateProfileImage:
            return "/api/v1/users/me/image"
        case .updateName:
            return "/api/v1/users/me/name"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin, .kakaoLogin, .refreshToken:
            return .post
        case .updateProfileImage, .updateName:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case let .appleLogin(_, fcmToken):
            return .requestJSONEncodable(SocialLoginRequestModel(provider: "APPLE", fcmToken: fcmToken))
        case let .kakaoLogin(_, fcmToken):
            return .requestJSONEncodable(SocialLoginRequestModel(provider: "KAKAO", fcmToken: fcmToken))
        case .refreshToken:
            return .requestPlain
        case let .updateProfileImage(imageData, fileName, mimeType):
            let formData = MultipartFormData(provider: .data(imageData), name: "image", fileName: fileName, mimeType: mimeType)
            return .uploadMultipart([formData])
        case let .updateName(name):
            return .requestParameters(
                parameters: ["name": name],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appleLogin(let identityToken, _):
            return ["Authorization": identityToken, "Content-Type": "application/json"]
        case .kakaoLogin(let accessToken, _):
            return ["Authorization": accessToken, "Content-Type": "application/json"]
        case .refreshToken(let refreshToken):
            return ["Authorization": refreshToken, "Content-Type": "application/json"]
        case .updateProfileImage:
            guard let token = DefaultKeychainService.shared.accessToken else {
                return ["Content-Type": "multipart/form-data"]
            }
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "multipart/form-data"
            ]
        case .updateName:
            guard let token = DefaultKeychainService.shared.accessToken else {
                fatalError("No access token available")
            }
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
}
