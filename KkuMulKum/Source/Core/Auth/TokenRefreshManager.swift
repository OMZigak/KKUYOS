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
    
    // 대기 중인 콜백을 저장하는 배열
    private var pendingCompletions: [(Result<String, Error>) -> Void] = []
    
    // 디바운싱 매커니즘을 위한 work item
    private var refreshWorkItem: DispatchWorkItem?
    
    // 네트워크 요청 횟수를 추적하는 카운터
    private var requestCount = 0
    private let maxRequestRetries = 3
    
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
            
            // 이미 토큰 리프레시 진행 중이면 대기열에 추가
            if self.isRefreshing {
                self.pendingCompletions.append(completion)
                return
            }
            
            // 리프레시 토큰 확인
            guard let currentRefreshToken = self.authService.getRefreshToken() else {
                completion(.failure(AuthError.tokenRefreshFailed))
                return
            }
            
            // 리프레시 진행 상태로 변경하고 현재 요청 추가
            self.isRefreshing = true
            self.pendingCompletions.append(completion)
            
            // 디바운싱 구현: 짧은 시간 동안 추가 요청을 모아서 한 번에 처리
            self.refreshWorkItem?.cancel()
            
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.performTokenRefresh(with: currentRefreshToken)
            }
            
            self.refreshWorkItem = workItem
            
            // 20ms 지연으로 짧은 시간 내 다수 요청을 하나로 통합
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.02, execute: workItem)
        }
    }
    
    private func performTokenRefresh(with refreshToken: String) {
        requestCount += 1
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            guard let self = self else { return }
            
            self.queue.async {
                switch result {
                case .success(let response):
                    do {
                        let reissueResponse = try response.map(ResponseBodyDTO<ReissueModel>.self)
                        if reissueResponse.success, let data = reissueResponse.data {
                            if self.authService.saveAccessToken(data.accessToken) &&
                               self.authService.saveRefreshToken(data.refreshToken) {
                                self.handleSuccess(data.accessToken)
                            } else {
                                self.handleFailure(AuthError.tokenRefreshFailed)
                            }
                        } else {
                            self.handleFailure(AuthError.tokenRefreshFailed)
                        }
                    } catch {
                        self.handleFailure(error)
                    }
                    
                case .failure(let error):
                    // 지수 백오프 알고리즘으로 재시도
                    if self.shouldRetry() {
                        // 지수 백오프: 2^n * 100ms 대기
                        let delay = pow(2.0, Double(self.requestCount)) * 0.1
                        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
                            guard let self = self,
                                  let currentRefreshToken = self.authService.getRefreshToken() else { return }
                            self.performTokenRefresh(with: currentRefreshToken)
                        }
                    } else {
                        self.handleFailure(error)
                    }
                }
            }
        }
    }
    
    // 성공 처리 - 모든 대기 콜백에 성공 결과 전달
    private func handleSuccess(_ token: String) {
        // 삽입 순서 보존 알고리즘 적용 (FIFO)
        let callbacks = self.pendingCompletions
        self.pendingCompletions = []
        self.isRefreshing = false
        self.requestCount = 0
        
        DispatchQueue.main.async {
            callbacks.forEach { $0(.success(token)) }
        }
    }
    
    // 실패 처리 - 모든 대기 콜백에 실패 결과 전달
    private func handleFailure(_ error: Error) {
        let callbacks = self.pendingCompletions
        self.pendingCompletions = []
        self.isRefreshing = false
        self.requestCount = 0
        
        DispatchQueue.main.async {
            callbacks.forEach { $0(.failure(error)) }
        }
    }
    
    // 재시도 여부 결정 로직
    private func shouldRetry() -> Bool {
        return requestCount < maxRequestRetries
    }
}
