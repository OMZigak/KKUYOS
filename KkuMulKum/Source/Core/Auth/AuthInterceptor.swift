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

        guard authService.getRefreshToken() != nil else {
            _ = authService.clearTokens()
            completion(.success(urlRequest))
            return
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
}
