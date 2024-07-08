//
//  AppDelegate.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/24/24.
//
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // KakaoSDK 초기화 과정에서 앱 키를 동적으로 불러오기
        if let kakaoAppKey = fetchKakaoAppKeyFromPrivacyInfo() {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
            print("Kakao SDK initialized with app key: \(kakaoAppKey)")
        } else {
            print("Failed to load KAKAO_APP_KEY from PrivacyInfo.plist")
        }
        
        return true
    }
    
    func fetchKakaoAppKeyFromPrivacyInfo() -> String? {
        guard let path = Bundle.main.path(forResource: "PrivacyInfo", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
              let appKey = dict["NATIVE_APP_KEY"] as? String else {
            return nil
        }
        return appKey
    }
    
    // 카카오 로그인
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
