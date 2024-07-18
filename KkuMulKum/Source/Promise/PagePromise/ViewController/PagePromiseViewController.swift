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
    
    private let promiseInfoViewController: PromiseInfoViewController
    private let readyStatusViewController: ReadyStatusViewController
    private let tardyViewController: TardyViewController
    
    private lazy var promiseSegmentedControl = PagePromiseSegmentedControl(
        items: ["약속 정보", "준비 현황", "지각 꾸물이"]
    )
    
    private let promisePageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarBackButton()
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: Initialize

    init(promiseViewModel: PagePromiseViewModel) {
        self.promiseViewModel = promiseViewModel
        
        // TODO: 네트워크 통신 필요
        
        promiseInfoViewController = PromiseInfoViewController(
            promiseInfoViewModel: PromiseInfoViewModel(
                promiseInfoService: MockPromiseInfoService(),
                promiseID: promiseViewModel.promiseID.value
            )
        )
        
        readyStatusViewController = ReadyStatusViewController(
            readyStatusViewModel: ReadyStatusViewModel(
                readyStatusService: PromiseService(),
                promiseID: promiseViewModel.promiseID.value
            )
        )
        
        tardyViewController = TardyViewController(
            tardyViewModel: TardyViewModel(
                tardyService: MockTardyService(),
                promiseID: promiseViewModel.promiseID.value
            )
        )
        
        promiseViewControllerList = [
            promiseInfoViewController,
            readyStatusViewController,
            tardyViewController
        ]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup

    override func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: promiseViewModel.promiseName)
        
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
        
        tardyViewController.tardyView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTapped),
            for: .touchUpInside
        )
        
        tardyViewController.arriveView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTapped),
            for: .touchUpInside
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
    
    @objc
    func finishMeetingButtonDidTapped() {
        navigationController?.popViewController(animated: true)
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
