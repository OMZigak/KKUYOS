//
//  AuthInterceptor.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/17/24.
//

import Foundation

import Moya
import Alamofire

class AuthInterceptor: RequestInterceptor {
    let authService: AuthServiceType
    let provider: MoyaProvider<LoginTargetType>
    
    init(authService: AuthServiceType, provider: MoyaProvider<LoginTargetType>) {
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
            completion(.doNotRetry)
            return
        }
        
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let reissueResponse = try response.map(ResponseBodyDTO<ReissueModel>.self)
                    if reissueResponse.success, let data = reissueResponse.data,
                       let newAccessToken = data.accessToken,
                       let newRefreshToken = data.refreshToken {
                        self?.authService.saveAccessToken(newAccessToken)
                        self?.authService.saveRefreshToken(newRefreshToken)
                        completion(.retry)
                    } else {
                        self?.authService.clearTokens()
                        completion(.doNotRetry)
                    }
                } catch {
                    self?.authService.clearTokens()
                    completion(.doNotRetry)
                }
            case .failure:
                self?.authService.clearTokens()
                completion(.doNotRetry)
            }
        }
    }
}
