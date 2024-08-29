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
    case updateProfileImage(image: Data?, fileName: String?, mimeType: String?)
    case updateName(name: String)
    case getUserInfo
}

extension AuthTargetType: TargetType {
    var baseURL: URL {
        guard let url = Bundle.main.baseURL else {
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
        case .getUserInfo:
            return "/api/v1/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin, .kakaoLogin, .refreshToken:
            return .post
        case .updateProfileImage, .updateName:
            return .patch
        case .getUserInfo:
            return .get
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
            if let imageData = imageData, let fileName = fileName, let mimeType = mimeType {
                let formData = MultipartFormData(provider: .data(imageData), name: "image", fileName: fileName, mimeType: mimeType)
                return .uploadMultipart([formData])
            } else {
                return .requestPlain
            }
        case let .updateName(name):
            return .requestParameters(
                parameters: ["name": name],
                encoding: JSONEncoding.default
            )
        case .getUserInfo:
            return .requestPlain
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
        case .updateName, .getUserInfo:
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
