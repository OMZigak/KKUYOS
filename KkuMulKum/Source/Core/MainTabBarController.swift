//
//  MainTabBarController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit


final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    
    private let homeViewController: HomeViewController = HomeViewController().then {
        $0.tabBarItem.title = "홈"
        $0.tabBarItem.image =
        $0.tabBarItem.selectedImage =
    }
    
    private let groupViewController: GroupViewController = GroupViewController().then {
        $0.tabBarItem.title = "내 모임"
        $0.tabBarItem.image =
    }
    
    private let myViewController: MyViewController = MyViewController().then {
        $0.tabBarItem.title = "마이"
        $0.tabBarItem.image =
    }
    
    private let logoImageBarButtonItem: UIBarButtonItem = UIBarButtonItem().then {
        $0.image =
    }
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTabBar()
    }
    
    
    // MARK: - Functions
    
    private func setNavigationBar() {
        [
            homeViewController, groupViewController, myViewController
        ].forEach {
            $0.navigationItem.setLeftBarButton(logoImageBarButtonItem, animated: true)
        }
    }
    
    private func setTabBar() {
        self.tabBar.tintColor = .black
        
        setViewControllers([
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: groupViewController),
            UINavigationController(rootViewController: myViewController)
        ], animated: true)
    }
}
