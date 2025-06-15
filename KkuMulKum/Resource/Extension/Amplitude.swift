//
//  Amplitude.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/15/25.
//

import UIKit

import Amplitude

extension UIViewController {
    
    private static var previousScreen: String?
    
    func trackScreenView() {
        let screenName = String(describing: type(of: self))
        
        var properties: [String: Any] = [
            "screen_name": screenName,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        if let prevScreen = UIViewController.previousScreen {
            properties["previous_screen"] = prevScreen
        }
        
        Amplitude.instance().logEvent("screen_viewed", withEventProperties: properties)
        UIViewController.previousScreen = screenName
    }
}
