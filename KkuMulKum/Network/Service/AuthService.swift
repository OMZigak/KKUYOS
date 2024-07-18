//
//  AuthServiceType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/14/24.
//
import Foundation
import Moya

protocol AuthServiceType {
    func saveAccessToken(_ token: String) -> Bool
    func saveRefreshToken(_ token: String) -> Bool
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens() -> Bool
    func performRequest<T: ResponseModelType>(
        _ target: AuthTargetType,
        completion: @escaping (
            Result<T, NetworkError>
        ) -> Void
    )
}

class AuthService: AuthServiceType {
    private var keychainService: KeychainService
    private let provider = MoyaProvider<AuthTargetType>()
    
    init(keychainService: KeychainService = DefaultKeychainService.shared) {
        self.keychainService = keychainService
    }
    
    func saveAccessToken(_ token: String) -> Bool {
        keychainService.accessToken = token
        return keychainService.accessToken == token
    }
    
    func saveRefreshToken(_ token: String) -> Bool {
        keychainService.refreshToken = token
        return keychainService.refreshToken == token
    }
    
    func getAccessToken() -> String? {
        return keychainService.accessToken
    }
    
    func getRefreshToken() -> String? {
        return keychainService.refreshToken
    }
    
    func clearTokens() -> Bool {
        keychainService.accessToken = nil
        keychainService.refreshToken = nil
        return keychainService.accessToken == nil && keychainService.refreshToken == nil
    }
    
    func performRequest<T: ResponseModelType>(
        _ target: AuthTargetType,
        completion: @escaping (
            Result<
            T,
            NetworkError
            >
        ) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(
                        ResponseBodyDTO<T>.self,
                        from: response.data
                    )
                    if decodedResponse.success {
                        if let data = decodedResponse.data {
                            completion(.success(data))
                        } else {
                            completion(.failure(.decodingError))
                        }
                    } else {
                        let networkError = self.handleErrorResponse(decodedResponse.error)
                        completion(.failure(networkError))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    private func handleErrorResponse(_ error: ErrorResponse?) -> NetworkError {
        guard let error = error else {
            return .unknownError("Unknown error occurred")
        }
        
        switch error.code {
        case 40080:
            return .invalidImageFormat
        case 40081:
            return .imageSizeExceeded
        case 40420:
            return .userNotFound
        default:
            return .unknownError(error.message)
        }
    }
}
