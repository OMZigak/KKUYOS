//
//  AuthInterceptor.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/17/24.
//

import Foundation

import Moya
import Alamofire

enum AuthError: Error {
    case tokenRefreshFailed
}

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
                                    print("Token refreshed and saved successfully")
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

class AuthInterceptor: RequestInterceptor {
    private let tokenManager: TokenRefreshManager
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol, provider: MoyaProvider<AuthTargetType>) {
        self.authService = authService
        self.tokenManager = TokenRefreshManager(authService: authService, provider: provider)
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = authService.getAccessToken() else {
            completion(.success(urlRequest))
            return
        }
        
        if let expiration = getTokenExpiration(from: accessToken) {
            let currentTime = Date().timeIntervalSince1970
            if expiration - currentTime < 30 {
                tokenManager.refreshToken { result in
                    switch result {
                    case .success(let newToken):
                        var request = urlRequest
                        request.headers.update(.authorization(bearerToken: newToken))
                        completion(.success(request))
                    case .failure:
                        completion(.success(urlRequest))
                    }
                }
                return
            }
        }
        
        var request = urlRequest
        request.headers.update(.authorization(bearerToken: accessToken))
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        tokenManager.refreshToken { [weak self] result in
            guard let self = self else {
                completion(.doNotRetry)
                return
            }
            
            switch result {
            case .success:
                completion(.retry)
            case .failure:
                _ = self.authService.clearTokens()
                completion(.doNotRetry)
            }
        }
    }
    
    private func getTokenExpiration(from token: String) -> TimeInterval? {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3,
              let payload = Data(base64Encoded: parts[1].padding(toLength: ((parts[1].count + 3) / 4) * 4,
                                                                 withPad: "=",
                                                                 startingAt: 0)),
              let json = try? JSONSerialization.jsonObject(with: payload, options: []) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return nil
        }
        return exp
    }
}
