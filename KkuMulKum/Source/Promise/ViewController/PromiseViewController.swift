//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PromiseViewController: BaseViewController {
    private let promiseViewModel = PromiseViewModel()
    
    private lazy var promiseSegmentedControl = PromiseSegmentedControl(items: ["약속 정보", "준비 현황", "지각 꾸물이"])
    
    private let promisePageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .vertical)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        view.backgroundColor = .white
        self.navigationItem.title = "기말고사 모각작"
        
        addChild(promisePageViewController)
        [
            promiseSegmentedControl,
            promisePageViewController.view
        ].forEach { view.addSubview($0) }
        
        promisePageViewController.setViewControllers([promiseViewModel.promiseViewControllerList[0]], direction: .forward, animated: true)
        
        promiseSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(-6)
            $0.height.equalTo(61)
        }
        
        promisePageViewController.view.snp.makeConstraints {
            $0.top.equalTo(promiseSegmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupAction() {
        promiseSegmentedControl.addTarget(self, action: #selector(didSegmentedControlIndexUpdated), for: .valueChanged)
    }
    
    override func setupDelegate() {
        promisePageViewController.delegate = self
        promisePageViewController.dataSource = self
    }
    
    @objc private func didSegmentedControlIndexUpdated() {
        let direction: UIPageViewController.NavigationDirection = promiseViewModel.currentPage.value <= promiseSegmentedControl.selectedSegmentIndex ? .forward : .reverse
        
        promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset((promiseSegmentedControl.bounds.width / CGFloat(promiseSegmentedControl.numberOfSegments)) * CGFloat(promiseSegmentedControl.selectedSegmentIndex))
        }
        
        promiseViewModel.didSegmentIndexChanged(index: promiseSegmentedControl.selectedSegmentIndex)
        
        promisePageViewController.setViewControllers([
            promiseViewModel.promiseViewControllerList[promiseViewModel.currentPage.value]
        ], direction: direction, animated: false)
    }
}


extension PromiseViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
