//
//  MeetingTargetType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/17/24.
//

import Foundation

import Moya

enum PromiseTargetType {
    case todayNext
}

extension PromiseTargetType: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "/api/v1/meetings") else {
            fatalError("Error: Invalid Meeting BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        }
    }
    
    var method: Moya.Method {
        switch self {
        }
    }
    
    var task: Task {
        switch self {
        }
    }
    
    var headers: [String : String]? {
        guard let token = DefaultKeychainService.shared.accessToken else {
            return ["Content-Type" : "application/json"]
        }
        
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(token)"
        ]
    }
}

