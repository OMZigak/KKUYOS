//
//  UserService.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

import Moya

final class MyPageUserService: MyPageUserServiceType {
    private var provider = MoyaProvider<UserTargetType>()
    
    init(provider: MoyaProvider<UserTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func getUserInfo() async throws -> MyPageUserInfo {
        return try await performRequest(.getUserInfo)
    }
    
    func performRequest<T: ResponseModelType>(_ target: UserTargetType) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<T>.self, from: response.data)
                        guard decodedResponse.success, let data = decodedResponse.data else {
                            throw decodedResponse.error.map(NetworkErrorMapper.mapErrorResponse) ??
                            NetworkError.unknownError("Unknown error occurred")
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
