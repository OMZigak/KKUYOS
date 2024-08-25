//
//  UserService.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

import Moya

final class MyPageUserService {
    private var provider = MoyaProvider<UserTargetType>()
    
    init(provider: MoyaProvider<UserTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func performRequest<T: ResponseModelType>(_ target: UserTargetType) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<T>.self, from: response.data)
                        if decodedResponse.success {
                            if let data = decodedResponse.data {
                                continuation.resume(returning: data)
                            } else if T.self == EmptyModel.self {
                                continuation.resume(returning: EmptyModel() as! T)
                            } else {
                                throw NetworkError.unknownError("Unexpected nil data")
                            }
                        } else {
                            throw decodedResponse.error.map(NetworkErrorMapper.mapErrorResponse) ??
                            NetworkError.unknownError("Unknown error occurred")
                        }
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

extension MyPageUserService : MyPageUserServiceProtocol {
    func getUserInfo() async throws -> LoginUserModel {
        return try await performRequest(.getUserInfo)
    }
    
    func unsubscribe(authCode: String) async throws {
        let _: EmptyModel = try await performRequest(.unsubscribe(authCode: authCode))
    }
    
    func logout() async throws {
        let _: EmptyModel = try await performRequest(.logout)
    }
}

