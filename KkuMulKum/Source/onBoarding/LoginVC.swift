//
//  LoginVC.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/1/24.
//
import UIKit

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import SnapKit

class LoginVC: UIViewController {
    private var nicknameLabel: UILabel!
    private var emailLabel: UILabel!
    private var loginButton: UIButton!
    private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        view.backgroundColor = .white

        nicknameLabel = UILabel()
        nicknameLabel.textColor = .black
        nicknameLabel.textAlignment = .center
        view.addSubview(nicknameLabel)

        emailLabel = UILabel()
        emailLabel.textColor = .black
        emailLabel.textAlignment = .center
        view.addSubview(emailLabel)

        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login with Kakao", for: .normal)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(loginButton)

        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        view.addSubview(logoutButton)
    }

    private func setupLayout() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func loginAction() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error = error {
                    print("Login failed: \(error.localizedDescription)")
                } else {
                    print("Login successful. Token: \(oauthToken?.accessToken ?? "")")
                    self?.setUserInfo()
                }
            }
        }
    }

    @objc private func logoutAction() {
        UserApi.shared.logout { [weak self] error in
            if let error = error {
                print("Logout failed: \(error.localizedDescription)")
            } else {
                print("Kakao logout success")
                self?.nicknameLabel.text = "Nickname:"
                self?.emailLabel.text = "Email:"
            }
        }
    }

    private func setUserInfo() {
        UserApi.shared.me { [weak self] user, error in
            if let error = error {
                print("Failed to get user info: \(error.localizedDescription)")
            } else {
                self?.nicknameLabel.text = "Nickname: \(user?.kakaoAccount?.profile?.nickname ?? "no nickname")"
                self?.emailLabel.text = "Email: \(user?.kakaoAccount?.email ?? "no email")"
            }
        }
    }
}
