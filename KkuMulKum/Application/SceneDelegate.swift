//
//  SceneDelegate.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/24/24.
//

import UIKit

import KakaoSDKAuth
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let loginViewModel = LoginViewModel()
    var pendingNotificationData: [String: Any]?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchScreenViewController = launchScreenStoryboard.instantiateInitialViewController()
        
        self.window?.rootViewController = launchScreenViewController
        self.window?.makeKeyAndVisible()
        
        if let notificationResponse = connectionOptions.notificationResponse {
            let userInfo = notificationResponse.notification.request.content.userInfo
            handleNotification(userInfo: userInfo)
        }
        
        print("Setting up navigation pulse subscription")
        loginViewModel.navigationPulse.subscribe(with: self) { [weak self] (owner, navigation) in
            print("🚀 Navigation pulse received: \(navigation)")
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch navigation {
                case .toMain:
                    self.showMainScreen()
                    print("🏠 Navigating to main screen")
                case .toOnboarding:
                    let nicknameViewModel = NicknameViewModel()
                    let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
                    let navigationController = UINavigationController(
                        rootViewController: nicknameViewController,
                        isBorderNeeded: false
                    )
                    self.animateRootViewControllerChange(to: navigationController)
                    print("👤 Navigating to onboarding")

                case .showError(let message):
                    print("Login error: \(message)")
                    self.showLoginScreen()
                }
            }
        }
        
        performAutoLogin()
    }
    
    private func performAutoLogin() {
        print("Performing auto login")
        loginViewModel.autoLogin { [weak self] success in
            DispatchQueue.main.async {
                if !success {
                    self?.showLoginScreen()
                }
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
     func showMainScreen() {
        let mainTabBarController = MainTabBarController()
        let navigationController = UINavigationController(
            rootViewController: mainTabBarController,
            isBorderNeeded: false
        )
        navigationController.isNavigationBarHidden = true
        
        animateRootViewControllerChange(to: navigationController)
        
        if let notificationData = pendingNotificationData {
            handleNotificationNavigation(data: notificationData)
            pendingNotificationData = nil
        }
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        animateRootViewControllerChange(to: loginViewController)
    }
    
    func animateRootViewControllerChange(to newRootViewController: UIViewController) {
        guard let window = self.window else { return }
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = newRootViewController
            UIView.setAnimationsEnabled(oldState)
        })
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let notificationData = pendingNotificationData {
            handleNotificationNavigation(data: notificationData)
            pendingNotificationData = nil
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
        if let data = userInfo["data"] as? [String: Any] {
            handleNotificationNavigation(data: data)
        }
    }
    
    private func handleNotificationNavigation(data: [String: Any]) {
        guard let screen = data["screen"] as? String,
              let promiseId = data["promiseId"] as? Int else {
            return
        }
        
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            pendingNotificationData = data
            return
        }
        
        switch screen {
        case "readyStatus":
            let promiseViewModel = PromiseViewModel(promiseID: promiseId, service: PromiseService())
            let readyStatusVC = ReadyStatusViewController(viewModel: promiseViewModel)
            navigationController.pushViewController(readyStatusVC, animated: true)
        default:
            break
        }
    }
}
