//
//  AppDelegate.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/24/24.
//

import UIKit

import KakaoSDKCommon
import Amplitude
import KakaoSDKAuth
import Firebase
import FirebaseMessaging
import UserNotifications

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
        
        if let amplitudeKey = Bundle.main.privacyInfo?["AMPLITUDE_API_KEY"] as? String {
            Amplitude.instance().initializeApiKey(amplitudeKey)
            print("🎯 Amplitude 초기화 완료: \(amplitudeKey)")
            
            print("🔍 앱 최초 실행 체크 시작...")
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "has_launched_before")
            print("🔍 첫 실행 여부: \(isFirstLaunch)")
            
            if isFirstLaunch {
                print("🎯 앱 최초 실행 이벤트 전송!")
                Amplitude.instance().logEvent("app_first_launch", withEventProperties: [
                    "install_date": ISO8601DateFormatter().string(from: Date()),
                    "device_model": UIDevice.current.model,
                    "ios_version": UIDevice.current.systemVersion,
                    "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
                ])
                UserDefaults.standard.set(true, forKey: "has_launched_before")
                UserDefaults.standard.set(Date(), forKey: "first_launch_date")
                print("🎯 최초 실행 플래그 저장 완료!")
            } else {
                print("🔍 이미 실행한 적 있는 앱")
            }
            
            print("🎯 세션 시작 이벤트 전송!")
            Amplitude.instance().logEvent("app_session_start", withEventProperties: [
                "session_id": UUID().uuidString,
                "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
                "device_model": UIDevice.current.model,
                "ios_version": UIDevice.current.systemVersion,
                "session_start_time": ISO8601DateFormatter().string(from: Date())
            ])
            
            print("🔍 방문주기 추적 시작...")
            trackVisitFrequency()
            
            UserDefaults.standard.set(Date(), forKey: "session_start_time")
            print("🎯 AppDelegate Amplitude 설정 완료!")
            
        } else {
            print("❌ AMPLITUDE_API_KEY를 PrivacyInfo.plist에서 찾을 수 없음")
        }
        
        setupFirebase(application: application)
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 이탈 지점 및 앱 내 지속시간 추적
        let sessionDuration = calculateSessionDuration()
        
        Amplitude.instance().logEvent("app_backgrounded", withEventProperties: [
            "session_duration_seconds": sessionDuration,
            "session_duration_category": getSessionDurationCategory(sessionDuration),
            "exit_point": getCurrentScreenName(),
            "background_time": ISO8601DateFormatter().string(from: Date())
        ])
        
        // 마지막 사용일 저장
        UserDefaults.standard.set(Date(), forKey: "last_used_date")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // 앱 재진입 시
        Amplitude.instance().logEvent("app_foregrounded", withEventProperties: [
            "foreground_time": ISO8601DateFormatter().string(from: Date())
        ])
        
        // 새로운 세션 시작 시간 기록
        UserDefaults.standard.set(Date(), forKey: "session_start_time")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 앱 완전 종료 시
        let sessionDuration = calculateSessionDuration()
        
        Amplitude.instance().logEvent("app_terminated", withEventProperties: [
            "total_session_duration": sessionDuration,
            "termination_time": ISO8601DateFormatter().string(from: Date())
        ])
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.handleNotification(userInfo: userInfo)
        }
        completionHandler(.newData)
    }
    
    // MARK: - Helper Methods
    
    private func trackVisitFrequency() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        if let lastUsedDate = UserDefaults.standard.object(forKey: "last_used_date") as? Date {
            let daysSinceLastUse = calendar.dateComponents([.day], from: lastUsedDate, to: currentDate).day ?? 0
            
            let frequencyCategory = getVisitFrequencyCategory(daysSinceLastUse)
            
            Amplitude.instance().logEvent("app_visit_frequency", withEventProperties: [
                "days_since_last_use": daysSinceLastUse,
                "frequency_category": frequencyCategory,
                "last_used_date": ISO8601DateFormatter().string(from: lastUsedDate),
                "current_date": ISO8601DateFormatter().string(from: currentDate)
            ])
        }
    }
    
    private func getVisitFrequencyCategory(_ days: Int) -> String {
        switch days {
        case 0: return "same_day"
        case 1: return "daily"
        case 2...7: return "weekly"
        case 8...30: return "monthly"
        case 31...90: return "quarterly"
        default: return "rare"
        }
    }
    
    private func calculateSessionDuration() -> TimeInterval {
        if let sessionStartTime = UserDefaults.standard.object(forKey: "session_start_time") as? Date {
            return Date().timeIntervalSince(sessionStartTime)
        }
        return 0
    }
    
    private func getSessionDurationCategory(_ duration: TimeInterval) -> String {
        switch duration {
        case 0..<30: return "very_short"
        case 30..<120: return "short"
        case 120..<300: return "medium"
        case 300..<900: return "long"
        default: return "very_long"
        }
    }
    
    private func getCurrentScreenName() -> String {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let topVC = window.rootViewController?.topMostViewController() else {
            return "Unknown"
        }
        return String(describing: type(of: topVC))
    }
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        completionHandler([.banner, .sound])
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.handleNotification(userInfo: userInfo)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.handleNotification(userInfo: userInfo)
        }
        
        completionHandler()
    }
}

// MARK: - UIViewController Extension

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        } else if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? nav
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}
