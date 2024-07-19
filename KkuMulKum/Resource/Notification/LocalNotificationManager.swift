//
//  LocalNotificationManager.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/17/24.
//

import Foundation

import UserNotifications

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Authorization request error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, triggerDate: Date, identifier: String,
        completion: @escaping (
            Error?
        ) -> Void
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [.year, .month,.day, .hour, .minute, .second ],
            from: triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
