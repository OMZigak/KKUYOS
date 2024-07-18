//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PagePromiseViewController: BaseViewController {
    
    
    // MARK: Property

    private let promiseViewModel: PagePromiseViewModel
    
    // TODO: 서버 연결 시 데이터 바인딩 필요
    private var promiseViewControllerList: [BaseViewController] = []
    
    private lazy var promiseSegmentedControl = PagePromiseSegmentedControl(
        items: ["약속 정보", "준비 현황", "지각 꾸물이"]
    )
    
    private let promisePageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical
    )
    
    
    // MARK: - Setup
    
    init(promiseViewModel: PagePromiseViewModel) {
        self.promiseViewModel = promiseViewModel
        
        // TODO: 네트워크 통신 필요
        
        promiseViewControllerList = [
            PromiseInfoViewController(
                promiseInfoViewModel: PromiseInfoViewModel(
                    promiseInfoService: MockPromiseInfoService(),
                    promiseID: promiseViewModel.promiseID.value
                )
            ),
            ReadyStatusViewController(
                readyStatusViewModel: ReadyStatusViewModel(
                    readyStatusService: MockReadyStatusService(),
                    promiseID: promiseViewModel.promiseID.value
                )
            ),
            TardyViewController(
                tardyViewModel: TardyViewModel(
                    tardyService: MockTardyService(),
                    promiseID: promiseViewModel.promiseID.value
                )
            )
        ]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}


// MARK: - Extension

extension PagePromiseViewController {
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
        
        promiseViewModel.segmentIndexDidChanged(
            index: promiseSegmentedControl.selectedSegmentIndex
        )
        
        promisePageViewController.setViewControllers([
            promiseViewControllerList[promiseViewModel.currentPage.value]
        ], direction: direction, animated: false)
    }
}



// MARK: - UIPageViewControllerDelegate

extension PagePromiseViewController: UIPageViewControllerDelegate {
    
}


// MARK: - UIPageViewControllerDataSource

extension PagePromiseViewController: UIPageViewControllerDataSource {
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
