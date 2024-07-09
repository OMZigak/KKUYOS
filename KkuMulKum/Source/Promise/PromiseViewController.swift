//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PromiseViewController: BaseViewController {
    private let promiseViewModel = PromiseViewModel()
    
    private lazy var promiseSegmentedControl = PromiseSegmentedControl(items: ["약속 정보",
                                                                          "준비 현황",
                                                                          "지각 꾸물이"])
    
    private let promisePageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                 navigationOrientation: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        view.backgroundColor = .white
        self.navigationItem.title = "기말고사 모각작"
        
        view.addSubview(promiseSegmentedControl)
        addChild(promisePageViewController)
        
        promiseSegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(-6)
            $0.height.equalTo(52)
        }
        
        promisePageViewController.view.snp.makeConstraints {
            $0.top.equalTo(promiseSegmentedControl.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        promisePageViewController.didMove(toParent: self)
    }
    
    override func setupAction() {
        promiseSegmentedControl.addTarget(self, action: #selector(didSegmentedControlIndexUpdated), for: .valueChanged)
    }
    
    override func setupDelegate() {
        promisePageViewController.delegate = self
        promisePageViewController.dataSource = self
    }
    
    @objc private func didSegmentedControlIndexUpdated() {
        promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset((promiseSegmentedControl.bounds.width / CGFloat(promiseSegmentedControl.numberOfSegments)) * CGFloat(promiseSegmentedControl.selectedSegmentIndex))
        }
    }
}


extension BaseViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
}
