//
//  Amplitude+CoreAnalytics.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/15/25.
//

import UIKit
import Amplitude

// MARK: - 화면 체류 시간 & 첫 클릭 추적
extension UIViewController {
    
    private static var previousScreen: String?
    private static var screenStartTimes: [String: Date] = [:]
    private static var hasTrackedFirstClick = false
    
    func trackScreenView() {
        let screenName = String(describing: type(of: self))
        
        var properties: [String: Any] = [
            "screen_name": screenName,
            "timestamp": Date().timeIntervalSince1970,
            "app_version": getAppVersion(),
            "device_type": UIDevice.current.userInterfaceIdiom == .pad ? "tablet" : "phone"
        ]
        
        if let prevScreen = UIViewController.previousScreen {
            properties["previous_screen"] = prevScreen
        }
        
        Amplitude.instance().logEvent("screen_viewed", withEventProperties: properties)
        UIViewController.previousScreen = screenName
    }
    
    func trackScreenEntered() {
        let screenName = String(describing: type(of: self))
        UIViewController.screenStartTimes[screenName] = Date()
        
        Amplitude.instance().logEvent("screen_entered", withEventProperties: [
            "screen_name": screenName,
            "entry_time": ISO8601DateFormatter().string(from: Date())
        ])
    }
    
    func trackScreenExited() {
        let screenName = String(describing: type(of: self))
        
        if let startTime = UIViewController.screenStartTimes[screenName] {
            let duration = Date().timeIntervalSince(startTime)
            
            Amplitude.instance().logEvent("screen_exited", withEventProperties: [
                "screen_name": screenName,
                "duration_seconds": duration,
                "duration_category": getDurationCategory(duration),
                "exit_time": ISO8601DateFormatter().string(from: Date())
            ])
            
            UIViewController.screenStartTimes.removeValue(forKey: screenName)
        }
    }
    
    func trackFirstClick(buttonName: String, screenName: String? = nil) {
        if !UIViewController.hasTrackedFirstClick {
            let screen = screenName ?? String(describing: type(of: self))
            
            let timeToFirstClick = getTimeToFirstClick()
            
            Amplitude.instance().logEvent("first_click_ever", withEventProperties: [
                "button_name": buttonName,
                "screen_name": screen,
                "time_to_first_click_seconds": timeToFirstClick,
                "first_click_time": ISO8601DateFormatter().string(from: Date())
            ])
            
            UIViewController.hasTrackedFirstClick = true
        }
    }
    
    func trackButtonClick(buttonName: String, additionalProperties: [String: Any] = [:]) {
        var properties: [String: Any] = [
            "button_name": buttonName,
            "screen_name": String(describing: type(of: self)),
            "timestamp": Date().timeIntervalSince1970
        ]
        
        properties.merge(additionalProperties) { (_, new) in new }
        
        Amplitude.instance().logEvent("button_clicked", withEventProperties: properties)
        
        trackFirstClick(buttonName: buttonName)
    }
    
    // MARK: - Helper Methods
    private func getDurationCategory(_ duration: TimeInterval) -> String {
        switch duration {
        case 0..<3: return "quick_glance"
        case 3..<10: return "brief_view"
        case 10..<30: return "normal_view"
        case 30..<60: return "long_view"
        case 60..<300: return "deep_view"
        default: return "very_deep_view"
        }
    }
    
    private func getTimeToFirstClick() -> TimeInterval {
        if let sessionStartTime = UserDefaults.standard.object(forKey: "session_start_time") as? Date {
            return Date().timeIntervalSince(sessionStartTime)
        }
        return 0
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
}

// MARK: - 회원가입 완료 추적
extension Amplitude {
    
    static func trackSignupCompleted(method: String, userId: String) {
        Amplitude.instance().logEvent("signup_completed", withEventProperties: [
            "signup_method": method,
            "user_id": userId,
            "signup_timestamp": Date().timeIntervalSince1970,
            "signup_date": ISO8601DateFormatter().string(from: Date()),
            "time_to_signup": getTimeToSignup()
        ])
        
        Amplitude.instance().setUserProperties([
            "signup_date": ISO8601DateFormatter().string(from: Date()),
            "signup_method": method,
            "user_id": userId
        ])
        
        Amplitude.instance().setUserId(userId)
    }
    
    private static func getTimeToSignup() -> TimeInterval {
        if let sessionStartTime = UserDefaults.standard.object(forKey: "session_start_time") as? Date {
            return Date().timeIntervalSince(sessionStartTime)
        }
        return 0
    }
}

// MARK: - 사용법 예시
/*
🎯 각 이벤트 사용법:

1. 회원가입 완료 시 (실제 회원가입 성공하는 곳에서 호출):
   Amplitude.trackSignupCompleted(method: "kakao", userId: "user123")

2. 버튼 클릭 시 (기존 HomeViewController처럼):
   trackButtonClick(buttonName: "login_button")

3. BaseViewController는 자동으로 화면 추적하므로 별도 작업 불필요

4. 이제 Amplitude에서 확인 가능한 지표들:
   - app_first_launch: 앱 최초 실행
   - signup_completed: 회원가입 완료
   - first_click_ever: 첫 클릭 지점
   - screen_exited: 화면별 체류 시간
   - app_backgrounded: 이탈 지점
   - app_visit_frequency: 방문 주기
   - app_session_start: 세션 시작 (DAU 계산용)
*/
