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
            print("PrivacyInfo.plist not found")
            fatalError("PrivacyInfo.plist not found")
        }
        
        guard let urlString = privacyInfo["BASE_URL"] as? String else {
            print("BASE_URL not found in PrivacyInfo.plist")
            fatalError("BASE_URL not found in PrivacyInfo.plist")
        }
        
        print("BASE_URL from PrivacyInfo.plist: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid BASE_URL in PrivacyInfo.plist: \(urlString)")
            fatalError("Invalid BASE_URL in PrivacyInfo.plist: \(urlString)")
        }
        
        print("Successfully created URL: \(url)")
        return url
    }
    
    var path: String {
        print("Getting path: /api/v1/auth/signin")
        return "/api/v1/auth/signin"
    }
    
    var method: Moya.Method {
        print("HTTP Method: POST")
        return .post
    }
    
    var task: Task {
        switch self {
        case let .appleLogin(_, fcmToken):
            print("Creating task for Apple Login with fcmToken: \(fcmToken)")
            return .requestParameters(
                parameters: ["provider": "APPLE", "fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        case let .kakaoLogin(_, fcmToken):
            print("Creating task for Kakao Login with fcmToken: \(fcmToken)")
            return .requestParameters(
                parameters: ["provider": "KAKAO", "fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appleLogin(let identityToken, _):
            print("Setting headers for Apple Login")
            return ["Authorization": identityToken, "Content-Type": "application/json"]
        case .kakaoLogin(let accessToken, _):
            print("Setting headers for Kakao Login")
            return ["Authorization": accessToken, "Content-Type": "application/json"]
        }
    }
}

extension Bundle {
    var privacyInfo: [String: Any]? {
        print("Attempting to read PrivacyInfo.plist")
        guard let url = self.url(forResource: "PrivacyInfo", withExtension: "plist") else {
            print("PrivacyInfo.plist file not found")
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            print("Failed to read data from PrivacyInfo.plist")
            return nil
        }
        guard let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            print("Failed to serialize PrivacyInfo.plist")
            return nil
        }
        print("Successfully read PrivacyInfo.plist")
        return result
    }
}
