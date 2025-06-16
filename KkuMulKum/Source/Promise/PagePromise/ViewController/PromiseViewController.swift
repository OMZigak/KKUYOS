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
    private let exitViewController = CustomActionSheetController(kind: .exitPromise)
    private let deleteViewController = CustomActionSheetController(kind: .deletePromise)
    private let promisePageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical
    )
    private var removePromiseViewContoller: RemovePromiseViewController = RemovePromiseViewController(promiseName: "")
    private var promiseViewControllerList: [BaseViewController] = []
    private lazy var promiseSegmentedControl = PagePromiseSegmentedControl(items: ["약속 정보", "준비 현황", "지각 꾸물이"])
    
    
    // MARK: - LifeCycle
    
    init(viewModel: PromiseViewModel) {
        self.viewModel = viewModel
        
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
        setupBinding()
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
        
        addChild(promisePageViewController)
        
        view.addSubviews(promiseSegmentedControl, promisePageViewController.view)
        
        promisePageViewController.setViewControllers(
            [promiseViewControllerList[0]],
            direction: .forward,
            animated: true
        )
        
        promiseSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(-6)
            $0.height.equalTo(Screen.height(60))
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
        
        promiseTardyViewController.rootView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTap),
            for: .touchUpInside
        )
        
        removePromiseViewContoller.exitButton.addTarget(
            self,
            action: #selector(exitButtonDidTap),
            for: .touchUpInside
        )
        
        removePromiseViewContoller.deleteButton.addTarget(
            self,
            action: #selector(deleteButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        promisePageViewController.dataSource = self
        exitViewController.delegate = self
        deleteViewController.delegate = self
    }
}


// MARK: - Extension

private extension PromiseViewController {
    func setupBinding() {
        viewModel.promiseInfo.bindOnMain(with: self) { owner, info in
            guard let info else { return }
            
            let moreButton = UIBarButtonItem(
                image: .imgMore.withRenderingMode(.alwaysOriginal),
                style: .plain,
                target: owner,
                action: #selector(owner.moreButtonDidTap)
            )
            
            owner.navigationItem.rightBarButtonItem = info.isParticipant ? moreButton : nil
            owner.removePromiseViewContoller.promiseNameLabel.text = info.promiseName
            owner.setupNavigationBarTitle(with: info.promiseName, isBorderHidden: true)
        }
        
        viewModel.currentPageIndex.bindOnMain(with: self) { owner, index in
            let direction: UIPageViewController.NavigationDirection = owner.viewModel.pageControlDirection ? .forward : .reverse
            let (width, count) = (
                owner.promiseSegmentedControl.bounds.width,
                owner.promiseSegmentedControl.numberOfSegments
            )
            
            owner.promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
                $0.leading.equalToSuperview().offset((width / CGFloat(count)) * CGFloat(index))
            }
            
            owner.promisePageViewController.setViewControllers([
                owner.promiseViewControllerList[index]
            ], direction: direction, animated: false)
        }
        
        viewModel.isFinishSuccess.bindOnMain(with: self) { owner, isSuccess in
            guard let isSuccess else { return }
            
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
                
                if let viewController = self.navigationController?.viewControllers.last {
                    let toast = Toast()
                    toast.show(message: "약속 마치기 성공!", view: viewController.view, position: .bottom, inset: 100)
                }
            }
        }
        
        viewModel.errorMessage.bindOnMain(with: self) { owner, message in
            guard let message else { return }
            let toast = Toast()
            
            toast.show(message: message, view: owner.view, position: .bottom, inset: 100)
        }
        
        viewModel.isExitSuccess.bindOnMain(with: self) { owner, isSuccess in
            owner.navigationController?.popViewController(animated: true)
        }
        
        viewModel.isDeleteSuccess.bindOnMain(with: self) { owner, isSuccess in
            owner.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    func didSegmentedControlIndexUpdated() {
        viewModel.pageControlDirection = viewModel.currentPageIndex.value <= promiseSegmentedControl.selectedSegmentIndex
        viewModel.currentPageIndex.value = promiseSegmentedControl.selectedSegmentIndex
    }
    
    @objc
    func finishMeetingButtonDidTap() {
        viewModel.updatePromiseCompletion()
    }
    
    @objc
    func moreButtonDidTap() {
        let bottomSheetViewController = BottomSheetViewController(
            contentViewController: removePromiseViewContoller,
            defaultHeight: Screen.height(232)
        )
        
        present(bottomSheetViewController, animated: true)
    }
    
    @objc
    func exitButtonDidTap() {
        dismiss(animated: false)
        present(exitViewController, animated: true)
    }
    
    @objc
    func deleteButtonDidTap() {
        dismiss(animated: false)
        present(deleteViewController, animated: true)
    }
}


// MARK: - CustomActionSheetDelegate

extension PromiseViewController: CustomActionSheetDelegate {
    func actionButtonDidTap(for kind: ActionSheetKind) {
        if kind == .deletePromise {
            viewModel.deletePromise()
            
            dismiss(animated: false)
        } else {
            viewModel.exitPromise()
            
            dismiss(animated: false)
        }
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
