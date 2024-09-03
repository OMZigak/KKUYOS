//
//  AppDelegate.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/24/24.
//

import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // KakaoSDK 초기화
        if let kakaoAppKey = Bundle.main.privacyInfo?["NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: kakaoAppKey, loggingEnable: true)
            print("Kakao SDK initialized with app key: \(kakaoAppKey)")
        } else {
            print("Failed to load KAKAO_APP_KEY from PrivacyInfo.plist")
        }
        
        setupFirebase(application: application)
        
        return true
    }

    // 카카오 로그인 URL 처리 (중복 제거)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
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

// MARK: - Firebase Setup

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func setupFirebase(application: UIApplication) {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
           
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // FCM 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM Token: \(token)")
                UserDefaults.standard.set(token, forKey: "FCMToken")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        if let token = fcmToken {
            let keychainAccessible: KeychainAccessible = DefaultKeychainAccessible()
            _ = keychainAccessible.saveToken("FCMToken", token)
            NotificationCenter.default.post(name: Notification.Name("FCMTokenReceived"), object: nil)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM Token: \(token)")
                let keychainAccessible: KeychainAccessible = DefaultKeychainAccessible()
                _ = keychainAccessible.saveToken("FCMToken", token)
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
