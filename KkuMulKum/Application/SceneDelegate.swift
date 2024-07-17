//
//  SceneDelegate.swift
//  KkuMulKum
//
//  Created by 이지훈 on 6/24/24.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let loginViewModel = LoginViewModel()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchScreenViewController = launchScreenStoryboard.instantiateInitialViewController()
        
        self.window?.rootViewController = launchScreenViewController
        self.window?.makeKeyAndVisible()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.loginViewModel.autoLogin { success in
                DispatchQueue.main.async {
                    if success {
                        self.showMainScreen()
                    } else {
                        self.showLoginScreen()
                    }
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
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    private func showMainScreen() {
        let mainTabBarController = MainTabBarController()
        let navigationController = UINavigationController(rootViewController: mainTabBarController)
        navigationController.isNavigationBarHidden = true
        
        animateRootViewControllerChange(to: navigationController)
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginViewController()
        animateRootViewControllerChange(to: loginViewController)
    }
    
    private func animateRootViewControllerChange(to newRootViewController: UIViewController) {
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
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
