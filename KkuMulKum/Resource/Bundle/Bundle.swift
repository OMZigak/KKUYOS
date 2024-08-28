//
//  Bundle.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/15/24.
//

import Foundation

extension Bundle {
    var privacyInfo: [String: Any]? {
        guard let url = self.url(forResource: "PrivacyInfo", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let result = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
              ) as? [String: Any] else {
            return nil
        }
        return result
    }
}

enum Configuration: String {
    case debug
    case release
    
    static var current: Configuration {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
    
    var baseURLKey: String {
        switch self {
        case .debug:
            return "BASE_URL_DEBUG"
        case .release:
            return "BASE_URL_RELEASE"
        }
    }
}

extension Bundle {
    var baseURL: URL? {
        guard let privacyInfo = self.privacyInfo,
              let urlString = privacyInfo[Configuration.current.baseURLKey] as? String,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
