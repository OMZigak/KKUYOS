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
