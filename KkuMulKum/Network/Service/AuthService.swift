//
//  AuthServiceType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/14/24.
//
import Foundation

import Moya

enum NetworkErrorMapper {
    static func mapErrorResponse(_ error: ErrorResponse) -> NetworkError {
        switch error.code {
        case 40080:
            return .invalidImageFormat
        case 40081:
            return .imageSizeExceeded
        case 40420:
            return .userNotFound
        default:
            return .apiError(code: error.code, message: error.message)
        }
    }
}

class AuthService: AuthServiceProtocol {
    private var keychainService: KeychainService
    private var provider = MoyaProvider<AuthTargetType>()
    
    init(keychainService: KeychainService = DefaultKeychainService.shared,
         provider: MoyaProvider<AuthTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.keychainService = keychainService
        self.provider = provider
    }
    
    func performRequest<T: ResponseModelType>(_ target: AuthTargetType) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("서버 응답 상태 코드: \(response.statusCode)")
                    print("서버 응답 데이터: \(String(data: response.data, encoding: .utf8) ?? "디코딩 불가")")
                    
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<T>.self, from: response.data)
                        guard decodedResponse.success else {
                            throw decodedResponse.error.map(NetworkErrorMapper.mapErrorResponse) ?? 
                            NetworkError.unknownError("Unknown error occurred")
                        }
                        guard let data = decodedResponse.data else {
                            if T.self == EmptyModel.self {
                                continuation.resume(returning: EmptyModel() as! T)
                            } else {
                                throw NetworkError.decodingError
                            }
                            return
                        }
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error is NetworkError ? error : NetworkError.decodingError)
                    }
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.networkError(error))
                }
                
            }
        }
    }
}


extension AuthService {
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
}
