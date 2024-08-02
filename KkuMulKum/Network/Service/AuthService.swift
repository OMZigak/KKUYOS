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
    func performRequest<T: ResponseModelType>(_ target: AuthTargetType, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class AuthService: AuthServiceType {
    private var keychainService: KeychainService
    private let provider = MoyaProvider<AuthTargetType>()
    
    init(provider: MoyaProvider<AuthTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
    }
    init(keychainService: KeychainService = DefaultKeychainService.shared) {
        self.keychainService = keychainService
        let plugin = MoyaLoggingPlugin()
        self.provider = MoyaProvider<AuthTargetType>(plugins: [plugin])
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
    
    func performRequest<T: ResponseModelType>(_ target: AuthTargetType, completion: @escaping (Result<T, NetworkError>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                print("서버 응답 상태 코드: \(response.statusCode)")
                print("서버 응답 데이터: \(String(data: response.data, encoding: .utf8) ?? "디코딩 불가")")
                
                do {
                    let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<T>.self, from: response.data)
                    if decodedResponse.success {
                        if let data = decodedResponse.data {
                            completion(.success(data))
                        } else if T.self == EmptyModel.self {
                            completion(.success(EmptyModel() as! T))
                        } else {
                            completion(.failure(.decodingError))
                        }
                    } else if let error = decodedResponse.error {
                        completion(.failure(self.mapErrorResponse(error)))
                    } else {
                        completion(.failure(.unknownError("Unknown error occurred")))
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    private func mapErrorResponse(_ error: ErrorResponse) -> NetworkError {
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
