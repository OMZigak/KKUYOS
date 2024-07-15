//
//  LoginService.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/15/24.
//
import Foundation
import Moya

enum LoginService {
    case appleLogin(identityToken: String, fcmToken: String)
    case kakaoLogin(accessToken: String, fcmToken: String)
}

extension LoginService: TargetType {
    var baseURL: URL {
        print("Attempting to get baseURL")
        guard let privacyInfo = Bundle.main.privacyInfo else {
            fatalError("PrivacyInfo.plist not found")
        }
        
        guard let urlString = privacyInfo["BASE_URL"] as? String else {
            fatalError("BASE_URL not found in PrivacyInfo.plist")
        }
            
        guard let url = URL(string: urlString) else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist: \(urlString)")
        }
        
        return url
    }
    
    var path: String {
        print("Getting path: /api/v1/auth/signin")
        return "/api/v1/auth/signin"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case let .appleLogin(_, fcmToken):
            return .requestParameters(
                parameters: ["provider": "APPLE", "fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        case let .kakaoLogin(_, fcmToken):
            return .requestParameters(
                parameters: ["provider": "KAKAO", "fcmToken": fcmToken],
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
        }
    }
}

extension Bundle {
    var privacyInfo: [String: Any]? {
        guard let url = self.url(forResource: "PrivacyInfo", withExtension: "plist") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let result = try? PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil
        ) as? [String: Any] else {
            return nil
        }
        return result
    }
}
