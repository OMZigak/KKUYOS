//
//  KakaoLogin.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//
import UIKit
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth
import KeychainAccess

class KakaoLoginVC: UIViewController {
    
    let keychain = Keychain(service: "KkuMulKum.yizihn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        printNativeAppKey()
        verifyLoginState()
    }
    
    private func setupUI() {
        setupLoginButton()
        setupLogoutButton()
    }
    
    private func setupLoginButton() {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login with KakaoTalk", for: .normal)
        loginButton.addTarget(self, action: #selector(loginWithKakao), for: .touchUpInside)
        loginButton.frame = CGRect(x: 20, y: 100, width: 280, height: 50)
        view.addSubview(loginButton)
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.frame = CGRect(x: 20, y: 160, width: 280, height: 50)
        view.addSubview(logoutButton)
    }
    
    private func verifyLoginState() {
        if let accessToken = loadToken() {
            print("Access token found: \(accessToken)")
            UserApi.shared.accessTokenInfo { [weak self] (_, error) in
                if let error = error {
                    print("Access token is invalid. Error: \(error)")
                    self?.clearTokens()
                } else {
                    print("Access token is valid.")
                    self?.fetchUserInfo()
                }
            }
        } else {
            print("No access token available, user needs to login.")
        }
    }
    
    private func printNativeAppKey() {
        if let appKey = nativeAppKey {
            let urlScheme = "kakao\(appKey)"
            print("Native App Key: \(appKey)")
            print("URL Scheme: \(urlScheme)")
        }
    }
    
    var nativeAppKey: String? {
        guard let path = Bundle.main.path(forResource: "PrivacyInfo", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
              let key = dict["NATIVE_APP_KEY"] as? String else {
            return nil
        }
        return key
    }
    
    @objc func loginWithKakao() {
        print("loginWithKakao called")
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                print("KakaoTalk login callback received")
                self?.handleLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            print("KakaoTalk is not installed, trying Kakao Account login...")
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                print("Kakao Account login callback received")
                self?.handleLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?) {
        print("handleLoginResult called")
        if let error = error {
            print("Login failed. Error: \(error.localizedDescription)")
            if let sdkError = error as? SdkError {
                print("SDK Error: \(sdkError)")
            }
            return
        }
        
        guard let token = oauthToken else {
            print("Login failed. No token received.")
            return
        }
        
        print("Login succeeded. Access token: \(token.accessToken)")
        saveToken(token.accessToken, refreshToken: token.refreshToken)
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print("Failed to get user info. Error: \(error)")
                return
            }
            
            guard let user = user else {
                print("No user information received.")
                return
            }
            
            print("User info received. Nickname: \(user.kakaoAccount?.profile?.nickname ?? "N/A")")
        }
    }
    
    @objc private func logout() {
        UserApi.shared.logout { [weak self] (error) in
            if let error = error {
                print("Logout failed. Error: \(error)")
            } else {
                print("Logout succeeded.")
                self?.clearTokens()
            }
        }
    }
    
    private func saveToken(_ accessToken: String, refreshToken: String) {
        do {
            try keychain.set(accessToken, key: "accessToken")
            try keychain.set(refreshToken, key: "refreshToken")
            print("Tokens saved successfully. AccessToken: \(accessToken)")
        } catch {
            print("Error saving tokens: \(error)")
        }
    }
    
    private func loadToken() -> String? {
        return keychain["accessToken"]
    }
    
    private func clearTokens() {
        do {
            try keychain.remove("accessToken")
            try keychain.remove("refreshToken")
            print("Tokens cleared from keychain")
        } catch {
            print("Error clearing tokens: \(error)")
        }
    }
}
