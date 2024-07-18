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
    let authService: AuthServiceType
    let provider: MoyaProvider<AuthTargetType>
    
    init(authService: AuthServiceType, provider: MoyaProvider<AuthTargetType>) {
        self.authService = authService
        self.provider = provider
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = authService.getAccessToken() else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        guard let refreshToken = authService.getRefreshToken() else {
            _ = authService.clearTokens()
            completion(.doNotRetry)
            return
        }
        
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let reissueResponse = try response.map(ResponseBodyDTO<ReissueModel>.self)
                    if reissueResponse.success, let data = reissueResponse.data {
                        let newAccessToken = data.accessToken
                        let newRefreshToken = data.refreshToken
                        _ = self?.authService.saveAccessToken(newAccessToken)
                        _ = self?.authService.saveRefreshToken(newRefreshToken)
                        print("Token refreshed successfully in interceptor")
                        completion(.retry)
                    } else {
                        print("Token refresh failed in interceptor: \(reissueResponse.error?.message ?? "Unknown error")")
                        _ = self?.authService.clearTokens()
                        completion(.doNotRetry)
                    }
                } catch {
                    print("Token refresh failed in interceptor: \(error)")
                    _ = self?.authService.clearTokens()
                    completion(.doNotRetry)
                }
            case .failure(let error):
                print("Network error during token refresh in interceptor: \(error)")
                _ = self?.authService.clearTokens()
                completion(.doNotRetry)
            }
        }
    }
}
