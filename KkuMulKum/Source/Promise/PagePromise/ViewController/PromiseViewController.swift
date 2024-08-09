//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PromiseViewController: BaseViewController {
    
    
    // MARK: Property

    private let viewModel: PromiseViewModel
    private let promiseInfoViewController: PromiseInfoViewController
    private let promiseReadyStatusViewController: ReadyStatusViewController
    private let promiseTardyViewController: TardyViewController
    private let promisePageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical
    )
    
    private var promiseViewControllerList: [BaseViewController] = []
    
    private lazy var promiseSegmentedControl = PagePromiseSegmentedControl(
        items: ["약속 정보", "준비 현황", "지각 꾸물이"]
    )
    
    
    // MARK: - LifeCycle
    
    init(viewModel: PromiseViewModel) {
        self.viewModel = viewModel
        
        viewModel.fetchPromiseInfo(promiseID: viewModel.promiseID)
        
        promiseInfoViewController = PromiseInfoViewController(viewModel: viewModel)
        promiseReadyStatusViewController = ReadyStatusViewController(viewModel: viewModel)
        promiseTardyViewController = TardyViewController(viewModel: viewModel)
        
        promiseViewControllerList = [
            promiseInfoViewController,
            promiseReadyStatusViewController,
            promiseTardyViewController
        ]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarBackButton()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - Setup

    override func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBarBackButton()
        
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
        
        promiseTardyViewController.tardyView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTap),
            for: .touchUpInside
        )
        
        promiseTardyViewController.arriveView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        promisePageViewController.dataSource = self
    }
}


// MARK: - Extension

private extension PromiseViewController {
    func setupBindings() {
        viewModel.promiseInfo.bind { info in
            DispatchQueue.main.async {
                self.setupNavigationBarTitle(with: info?.promiseName ?? "")
            }
        }
    }
    
    @objc private func didSegmentedControlIndexUpdated() {
        let condition = viewModel.currentPageIndex.value <= promiseSegmentedControl.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = condition ? .forward : .reverse
        let (width, count, selectedIndex) = (
            promiseSegmentedControl.bounds.width,
            promiseSegmentedControl.numberOfSegments,
            promiseSegmentedControl.selectedSegmentIndex
        )
        
        promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset((width / CGFloat(count)) * CGFloat(selectedIndex))
        }
        
        viewModel.segmentIndexDidChange(
            index: promiseSegmentedControl.selectedSegmentIndex
        )
        
        promisePageViewController.setViewControllers([
            promiseViewControllerList[viewModel.currentPageIndex.value]
        ], direction: direction, animated: false)
    }
    
    @objc
    func finishMeetingButtonDidTap() {
        promiseTardyViewController.viewModel.updatePromiseCompletion()
        
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - UIPageViewControllerDataSource

extension PromiseViewController: UIPageViewControllerDataSource {
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
