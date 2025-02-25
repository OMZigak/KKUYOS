//
//  LoginVM.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/9/24.
//

import UIKit
import AuthenticationServices

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import Moya
import FirebaseMessaging

enum LoginState {
    case notLogin
    case login
    case needOnboarding
}

enum LoginNavigation {
    case toMain
    case toOnboarding
    case showError(message: String)
}

class LoginViewModel: NSObject {
    // MARK: - Outputs
    // 현재 상태
    private(set) var loginState: LoginState = .notLogin {
        didSet {
            loginStateChanged?(loginState)
        }
    }
    
    // 상태 변경 콜백
    var loginStateChanged: ((LoginState) -> Void)?
    private var isLoggedOut = false
    
    // Pulse 이벤트들
    private(set) var loginResultPulse = Pulse<Result<SocialLoginResponseModel, Error>>()
    private(set) var navigationPulse = Pulse<LoginNavigation>()
    private(set) var errorPulse = Pulse<String>()
    
    // MARK: - Private properties
    private let provider: MoyaProvider<AuthTargetType>
    private var authService: AuthServiceProtocol
    private let authInterceptor: AuthInterceptor
    private let keychainAccessible: KeychainAccessible
    
    private let kakaoAppKey: String

    // MARK: - Initialization
    init(
        provider: MoyaProvider<AuthTargetType> = MoyaProvider<AuthTargetType>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        ),
        authService: AuthServiceProtocol = AuthService(),
        keychainAccessible: KeychainAccessible = DefaultKeychainAccessible()
    ) {
        if let appKey = Bundle.main.privacyInfo?["NATIVE_APP_KEY"] as? String {
            self.kakaoAppKey = appKey
        } else {
            fatalError("Failed to load NATIVE_APP_KEY from PrivacyInfo.plist")
        }
        
        self.provider = provider
        self.authService = authService
        self.authInterceptor = AuthInterceptor(authService: authService, provider: provider)
        self.keychainAccessible = keychainAccessible
        super.init()
        
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // errorPulse 발생 시 navigationPulse(showError)도 함께 발생시키기
        errorPulse.subscribe { [weak self] errorMessage in
            if !errorMessage.isEmpty {
                self?.navigationPulse.emit(.showError(message: errorMessage))
            }
        }
    }
    
    // MARK: - Public Methods
    func performAppleLogin(presentationAnchor: ASPresentationAnchor) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func performKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    func logout() {
        isLoggedOut = true
        _ = authService.clearTokens()
        loginState = .notLogin
    }
    
    // MARK: - Private Methods
    private func getFCMToken() -> String {
        return keychainAccessible.getToken("FCMToken") ?? "fcm_token_not_available"
    }
    
    private func getFCMTokenAsync(completion: @escaping (String) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                completion("fcm_token_not_available")
            } else if let token = token {
                UserDefaults.standard.set(token, forKey: "FCMToken")
                UserDefaults.standard.synchronize()
                completion(token)
            } else {
                completion("fcm_token_not_available")
            }
        }
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            errorPulse.emit(error.localizedDescription)
            return
        }
        
        if let token = oauthToken?.accessToken {
            getFCMTokenAsync { [weak self] fcmToken in
                self?.loginToServer(with: .kakaoLogin(accessToken: token, fcmToken: fcmToken))
            }
        } else {
            errorPulse.emit("No access token received")
        }
    }
    
    private func loginToServer(with loginTarget: AuthTargetType) {
        provider.request(loginTarget) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try response.map(
                        ResponseBodyDTO<SocialLoginResponseModel>.self
                    )
                    self?.handleLoginResponse(loginResponse)
                } catch {
                    self?.errorPulse.emit("Failed to decode response: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                self?.errorPulse.emit("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleLoginResponse(_ response: ResponseBodyDTO<SocialLoginResponseModel>) {
        print("Handling login response")
        if response.success, let data = response.data {
            saveTokens(
                accessToken: data.jwtTokenDTO.accessToken,
                refreshToken: data.jwtTokenDTO.refreshToken
            )
            
            loginResultPulse.emit(.success(data))
            
            // Pulse 리셋 (이전 이벤트 상태 초기화)
            navigationPulse.reset()
            
            if data.name != nil {
                print("Login successful, user has a name")
                loginState = .login
                print("🚀 Emitting navigation pulse to main")
                navigationPulse.emit(.toMain)
                
                // 디버깅용: 직접 화면 전환
                DispatchQueue.main.async {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    sceneDelegate?.showMainScreen()
                }
            } else {
                print("Login successful, but user needs onboarding")
                loginState = .needOnboarding
                print("🚀 Emitting navigation pulse to onboarding")
                navigationPulse.emit(.toOnboarding)
            }
        } else {
            if let error = response.error {
                errorPulse.emit(error.message)
            } else {
                errorPulse.emit("Unknown error occurred")
            }
            loginState = .notLogin
        }
    }
    
    func autoLogin(completion: @escaping (Bool) -> Void) {
        // 로그아웃 상태라면 자동 로그인 시도하지 않음
        if isLoggedOut {
            loginState = .notLogin
            completion(false)
            return
        }
        
        guard let refreshToken = authService.getRefreshToken() else {
            loginState = .notLogin
            completion(false)
            return
        }
        
        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let reissueResponse = try response.map(ResponseBodyDTO<RefreshTokenResponseModel>.self)
                    if reissueResponse.success, let data = reissueResponse.data {
                        let newAccessToken = data.accessToken
                        let newRefreshToken = data.refreshToken
                        self?.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken)
                        
                        self?.fetchUserInfo { success in
                            if success {
                                completion(true)
                            } else {
                                self?.clearTokensAndHandleError()
                                completion(false)
                            }
                        }
                    } else {
                        self?.clearTokensAndHandleError()
                        completion(false)
                    }
                } catch {
                    self?.clearTokensAndHandleError()
                    completion(false)
                }
            case .failure(let error):
                self?.clearTokensAndHandleError()
                completion(false)
            }
        }
    }
    
    private func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        provider.request(.getUserInfo) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let userInfoResponse = try response.map(ResponseBodyDTO<UserInfoModel>.self)
                    if userInfoResponse.success, let data = userInfoResponse.data {
                        if data.name != nil {
                            self?.loginState = .login
                            self?.navigationPulse.emit(.toMain)
                        } else {
                            self?.loginState = .needOnboarding
                            self?.navigationPulse.emit(.toOnboarding)
                        }
                        completion(true)
                    } else {
                        self?.clearTokensAndHandleError()
                        completion(false)
                    }
                } catch {
                    self?.clearTokensAndHandleError()
                    completion(false)
                }
            case .failure(let error):
                self?.clearTokensAndHandleError()
                completion(false)
            }
        }
    }
    
    private func clearTokensAndHandleError() {
        _ = authService.clearTokens()
        loginState = .notLogin
        
        if !isLoggedOut {
            errorPulse.emit("자동 로그인 실패. 다시 로그인해주세요.")
        }
        isLoggedOut = false
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) {
        let accessTokenSaved = authService.saveAccessToken(accessToken)
        let refreshTokenSaved = authService.saveRefreshToken(refreshToken)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            return
        }
        
        getFCMTokenAsync { [weak self] fcmToken in
            self?.loginToServer(with: .appleLogin(identityToken: tokenString, fcmToken: fcmToken))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        errorPulse.emit(error.localizedDescription)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
    }
}
