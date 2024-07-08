//
//  ViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/24/24.
//
import UIKit

import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth
import KeychainAccess

class ViewController: UIViewController {
    
    let keychain = Keychain(service: "KkuMulKum.yizihn")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLoginButton()
        printNativeAppKey()
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
    
    private func setupLoginButton() {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login with KakaoTalk", for: .normal)
        loginButton.addTarget(self, action: #selector(loginWithKakao), for: .touchUpInside)
        loginButton.frame = CGRect(x: 20, y: 100, width: 280, height: 50)
        view.addSubview(loginButton)
    }
    
    @objc func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("Error during KakaoTalk login: \(error)")
                } else if let token = oauthToken {
                    print("Login with KakaoTalk successful")
                    self?.saveToken(token.accessToken)
                }
            }
        } else {
            print("KakaoTalk is not installed, trying Kakao Account login...")
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("Error during Kakao Account login: \(error)")
                } else if let token = oauthToken {
                    print("Login with Kakao Account successful")
                    self?.saveToken(token.accessToken)
                }
            }
        }
    }
    
    private func saveToken(_ token: String) {
        do {
            try keychain.set(token, key: "accessToken")
            print("Token saved successfully")
        } catch {
            print("Error saving token: \(error)")
        }
    }
    
    func loadToken() -> String? {
        return keychain["accessToken"]
    }
}
