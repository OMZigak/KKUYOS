//
//  MainTabBarController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit


final class MainTabBarController: UITabBarController {
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    
    // MARK: - Functions
    
    
    private func setTabBar() {
        let homeViewController: HomeViewController = HomeViewController().then {
            $0.tabBarItem.title = "홈"
            $0.tabBarItem.image = .iconHome
        }
        
        let meetingListViewController = MeetingListViewController(
            viewModel: MeetingListViewModel(
                service: MockMeetingListService()
            )).then {
            $0.tabBarItem.title = "내 모임"
            $0.tabBarItem.image = .iconGroup
        }
        
        let myPageViewController: MyPageViewController = MyPageViewController().then {
            $0.tabBarItem.title = "마이"
            $0.tabBarItem.image = .iconMy
        }
        
        tabBar.unselectedItemTintColor = .gray2
        tabBar.tintColor = .maincolor
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        let homeNavigationController = UINavigationController(
            rootViewController: homeViewController
        )
        
        let meetingListNavigationController = UINavigationController(
            rootViewController: meetingListViewController
        )
        
        let myPageViewNavigationController = UINavigationController(
            rootViewController: myPageViewController
        )
        
        setViewControllers([
            homeNavigationController,
            meetingListNavigationController,
            myPageViewNavigationController
        ], animated: true)
    }
}
