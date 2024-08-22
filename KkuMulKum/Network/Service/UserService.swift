//
//  UserService.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

import Moya

protocol UserServiceType {
    func getUserInfo() async throws -> MyPageUserInfo
}

class UserService: UserServiceType {
    private var provider = MoyaProvider<UserTargetType>()
    
    init(provider: MoyaProvider<UserTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func getUserInfo() async throws -> MyPageUserInfo {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getUserInfo) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<MyPageUserInfo>.self, from: response.data)
                        guard decodedResponse.success, let userInfo = decodedResponse.data else {
                            throw decodedResponse.error.map(NetworkErrorMapper.mapErrorResponse) ??
                            NetworkError.unknownError("Unknown error occurred")
                        }
                        continuation.resume(returning: userInfo)
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
