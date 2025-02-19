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
    let authService: AuthServiceProtocol
    let provider: MoyaProvider<AuthTargetType>
    private let lock = NSLock()
    
    init(authService: AuthServiceProtocol, provider: MoyaProvider<AuthTargetType>) {
        self.authService = authService
        self.provider = provider
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = authService.getAccessToken() else {
            completion(.success(urlRequest))
            return
        }
        
        if let expiration = getTokenExpiration(from: accessToken) {
            let currentTime = Date().timeIntervalSince1970
            if expiration - currentTime < 30 {
                refreshToken { [weak self] result in
                    switch result {
                    case .success(let newToken):
                        var request = urlRequest
                        request.headers.update(.authorization(bearerToken: newToken))
                        completion(.success(request))
                    case .failure(_):
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
        
        refreshToken { [weak self] result in
            switch result {
            case .success(let newToken):
                var updatedRequest = request.request
                updatedRequest?.headers.update(.authorization(bearerToken: newToken))
                completion(.retry)
            case .failure(_):
                _ = self?.authService.clearTokens()
                completion(.doNotRetry)
            }
        }
    }
    
    private func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        lock.lock() 
        defer { lock.unlock() }
        
        guard let refreshToken = authService.getRefreshToken() else {
            completion(.failure(AuthError.tokenRefreshFailed))
            return
        }
        
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let reissueResponse = try response.map(ResponseBodyDTO<ReissueModel>.self)
                    if reissueResponse.success, let data = reissueResponse.data {
                        _ = self?.authService.saveAccessToken(data.accessToken)
                        _ = self?.authService.saveRefreshToken(data.refreshToken)
                        print("Token refreshed successfully")
                        completion(.success(data.accessToken))
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
    
    private func getTokenExpiration(from token: String) -> TimeInterval? {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3,
              let payload = parts[1].base64Decoded(),
              let json = try? JSONSerialization.jsonObject(with: payload, options: []) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return nil
        }
        return exp
    }
}

extension String {
    func base64Decoded() -> Data? {
        var base64 = self
        base64 = base64.padding(toLength: ((base64.count + 3) / 4) * 4,
                               withPad: "=",
                               startingAt: 0)
        return Data(base64Encoded: base64)
    }
}
