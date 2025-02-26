//
//  TokenRefreshManager.swift
//  KkuMulKum
//
//  Created by 이지훈 on 2/20/25.
//

import Foundation

import Moya
import Alamofire

class TokenRefreshManager {
    private let authService: AuthServiceProtocol
    private let provider: MoyaProvider<AuthTargetType>
    private var isRefreshing = false
    private let queue = DispatchQueue(label: "com.TokenRefreshManager.queue")
    
    init(authService: AuthServiceProtocol, provider: MoyaProvider<AuthTargetType>) {
        self.authService = authService
        self.provider = provider
    }
    
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(AuthError.tokenRefreshFailed))
                return
            }
            
            if self.isRefreshing {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                    self.refreshToken(completion: completion)
                }
                return
            }
            
            self.isRefreshing = true
            
            guard let currentRefreshToken = self.authService.getRefreshToken() else {
                self.isRefreshing = false
                completion(.failure(AuthError.tokenRefreshFailed))
                return
            }
            
            self.provider.request(.refreshToken(refreshToken: currentRefreshToken)) { [weak self] result in
                guard let self = self else {
                    completion(.failure(AuthError.tokenRefreshFailed))
                    return
                }
                
                self.queue.async {
                    self.isRefreshing = false
                    
                    switch result {
                    case .success(let response):
                        do {
                            let reissueResponse = try response.map(ResponseBodyDTO<ReissueModel>.self)
                            if reissueResponse.success, let data = reissueResponse.data {
                                if self.authService.saveAccessToken(data.accessToken) &&
                                   self.authService.saveRefreshToken(data.refreshToken) {
                                    completion(.success(data.accessToken))
                                } else {
                                    completion(.failure(AuthError.tokenRefreshFailed))
                                }
                            } else {
                                completion(.failure(AuthError.tokenRefreshFailed))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
