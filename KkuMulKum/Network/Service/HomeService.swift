//
//  HomeService.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/16/24.
//

import Foundation

import Moya

final class HomeService {
    let provider: MoyaProvider<HomeTargetType>
    
    init(provider: MoyaProvider<HomeTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func request<T: Decodable>(
        with request: HomeTargetType
    ) async throws -> ResponseBodyDTO<T>? {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(request) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(
                            ResponseBodyDTO<T>.self,
                            from: response.data
                        )
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
