//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class BasePromiseViewController: BaseViewController {
    private let promiseViewModel = BasePromiseViewModel()
    
    private let promiseViewControllerList: [BaseViewController] = [
        PromiseInfoViewController(),
        ReadyStatusViewController(),
        TardyViewController()
    ]
    
    private lazy var promiseSegmentedControl = BasePromiseSegmentedControl(
        items: ["약속 정보", "준비 현황", "지각 꾸물이"]
    )
    
    private let promisePageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle(with: "기말고사 모각작")
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        addChild(promisePageViewController)
        
        view.addSubviews(
            promiseSegmentedControl,
            promisePageViewController.view
        )
        
        promisePageViewController.setViewControllers(
            [promiseViewControllerList[0]],
            direction: .forward,
            animated: true
        )
        
        promiseSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(-6)
            $0.height.equalTo(60)
        }
        
        promisePageViewController.view.snp.makeConstraints {
            $0.top.equalTo(promiseSegmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupAction() {
        promiseSegmentedControl.addTarget(
            self,
            action: #selector(didSegmentedControlIndexUpdated),
            for: .valueChanged
        )
    }
    
    override func setupDelegate() {
        promisePageViewController.delegate = self
        promisePageViewController.dataSource = self
    }
    
    @objc private func didSegmentedControlIndexUpdated() {
        let condition = promiseViewModel.currentPage.value <= promiseSegmentedControl.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = condition ? .forward : .reverse
        let (width, count, selectedIndex) = (
            promiseSegmentedControl.bounds.width,
            promiseSegmentedControl.numberOfSegments,
            promiseSegmentedControl.selectedSegmentIndex
        )
        
        promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset((width / CGFloat(count)) * CGFloat(selectedIndex))
        }
        
        promiseViewModel.didSegmentIndexChanged(index: promiseSegmentedControl.selectedSegmentIndex)
        
        promisePageViewController.setViewControllers([
            promiseViewControllerList[promiseViewModel.currentPage.value]
        ], direction: direction, animated: false)
    }
}


extension BasePromiseViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }
}
