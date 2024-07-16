////
////  KeychainService.swift
////  KkuMulKum
////
////  Created by 이지훈 on 7/15/24.
////
//
//import Foundation
//
//protocol KeychainService {
//    var accessToken: String? { get set }
//    var refreshToken: String? { get set }
//    var accessTokenExpiresIn: Int? { get set }
//}
//
//class DefaultKeychainService: KeychainService {
//    static let shared = DefaultKeychainService()
//    private init() {}
//    
//    private let keychainAccess = DefaultKeychainAccessible()
//    
//    struct Key {
//        static let tempAccessToken = "tempAccessToken"
//        static let tempRefreshToken = "tempRefreshToken"
//        static let tempAccessTokenExpiresIn = "tempAccessTokenExpiresIn"
//        
//        static let accessToken = "accessToken"
//        static let refreshToken = "refreshToken"
//        static let accessTokenExpiresIn = "accessTokenExpiresIn"
//    }
//    
//    var tempAccessToken: String? {
//        get {
//            keychainAccess.getToken(Key.tempAccessToken)
//        }
//        set {
//            if newValue != nil {
//                keychainAccess.saveToken(Key.tempAccessToken, newValue ?? "")
//            } else {
//                keychainAccess.remove(Key.tempAccessToken)
//            }
//        }
//    }
//    
//    var tempRefreshToken: String? {
//        get {
//            keychainAccess.getToken(Key.tempRefreshToken)
//        }
//        set {
//            if newValue != nil {
//                keychainAccess.saveToken(Key.tempRefreshToken, newValue ?? "")
//            } else {
//                keychainAccess.remove(Key.tempRefreshToken)
//            }
//        }
//    }
//    
//    var tempAccessTokenExpiresIn: Int? {
//        get {
//            keychainAccess.getExpiresIn(Key.tempAccessTokenExpiresIn)
//        }
//        set {
//            if newValue != nil {
//                keychainAccess.saveExpiresIn(Key.tempAccessTokenExpiresIn, newValue ?? 0)
//            } else {
//                keychainAccess.remove(Key.tempAccessTokenExpiresIn)
//            }
//        }
//    }
//    
//    var accessToken: String? {
//        get {
//            keychainAccess.getToken(Key.accessToken)
//        }
//        set {
//            if newValue != nil {
//                keychainAccess.saveToken(Key.accessToken, newValue ?? "")
//            } else {
//                keychainAccess.remove(Key.accessToken)
//            }
//        }
//    }
//    
//    var refreshToken: String? {
//        get {
//            keychainAccess.getToken(Key.refreshToken)
//        }
//        set {
//            if newValue != nil {
//                keychainAccess.saveToken(Key.refreshToken, newValue ?? "")
//            } else {
//                keychainAccess.remove(Key.refreshToken)
//            }
//        }
//    }
//    
//    var accessTokenExpiresIn: Int? {
//        get {
//            keychainAccess.getExpiresIn(Key.accessTokenExpiresIn)
//        }
//        set {
//            if newValue != nil {
//                keychainAccess.saveExpiresIn(Key.accessTokenExpiresIn, newValue ?? 0)
//            } else {
//                keychainAccess.remove(Key.accessTokenExpiresIn)
//            }
//        }
//    }
//}
