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
        $0.tabBarItem.image = .iconHome
    }
    
    private let groupViewController: GroupViewController = GroupViewController().then {
        $0.tabBarItem.title = "내 모임"
        $0.tabBarItem.image = .iconGroup
    }
    
    private let myViewController: MyViewController = MyViewController().then {
        $0.tabBarItem.title = "마이"
        $0.tabBarItem.image = .iconMy
    }
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    
    // MARK: - Functions
    
    private func setTabBar() {
        tabBar.unselectedItemTintColor = .gray2
        tabBar.tintColor = .maincolor
        
        setViewControllers([
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: groupViewController),
            UINavigationController(rootViewController: myViewController)
        ], animated: true)
    }
}
