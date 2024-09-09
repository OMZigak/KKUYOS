//
//  MeetingInfoViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class MeetingInfoViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let viewModel: MeetingInfoViewModel
    
    private let viewWillAppearRelay = PublishRelay<Void>()
    private let actionButtonDidTapRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let rootView = MeetingInfoView()
    
    
    // MARK: - Initializer
    
    init(viewModel: MeetingInfoViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        viewWillAppearRelay.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupView() {
        setupNavigationBarBackButton()
        setupNavigationBarRightButton()
    }
    
    override func setupAction() {
        rootView.createPromiseButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.navigateToAddPromise()
            }
            .disposed(by: disposeBag)
    }
}

private extension MeetingInfoViewController {
    func bindViewModel() {
        let promiseCellDidSelect = rootView.promiseListView.rx.itemSelected
            .map { $0.item }
            .asObservable()
        
        let input = MeetingInfoViewModel.Input(
            viewWillAppear: viewWillAppearRelay,
            createPromiseButtonDidTap: rootView.createPromiseButtonDidTap,
            actionButtonDidTapRelay: actionButtonDidTapRelay,
            selectedSegmentedIndex: rootView.selectedSegmentIndex,
            promiseCellDidSelect: promiseCellDidSelect
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.info
            .drive(with: self) { owner, meetingInfo in
                guard let info = meetingInfo else { return }
                owner.setupNavigationBarTitle(with: info.name)
                owner.rootView.configureInfo(
                    createdAt: info.createdAt,
                    metCount: info.metCount
                )
            }
            .disposed(by: disposeBag)
        
        output.memberCount
            .drive(with: self) { owner, count in
                owner.rootView.configureMemberCount(count)
            }
            .disposed(by: disposeBag)
        
        output.members
            .drive(rootView.memberListView.rx.items(
                cellIdentifier: MeetingMemberCell.reuseIdentifier,
                cellType: MeetingMemberCell.self
            )) { index, member, cell in
                if index == 0 {
                    cell.configure(with: .add(delegate: self))
                    return
                }
                
                cell.configure(with: .profile(member: member))
            }
            .disposed(by: disposeBag)
        
        output.promises
            .map { [weak self] promises in
                self?.rootView.configureEmptyView(with: !promises.isEmpty)
                return promises
            }
            .drive(rootView.promiseListView.rx.items(
                cellIdentifier: MeetingPromiseCell.reuseIdentifier,
                cellType: MeetingPromiseCell.self
            )) { index, promise, cell in
                cell.configure(model: promise)
            }
            .disposed(by: disposeBag)
        
        output.isExitMeetingSucceed
            .drive(with: self) { owner, result in
                if result {
                    owner.navigationController?.popViewController(animated: true)
                } else {
                    Toast().show(
                        message: "다시 시도해 주세요.",
                        view: owner.view,
                        position: .bottom,
                        inset: Screen.height(100)
                    )
                }
            }
            .disposed(by: disposeBag)
        
        output.navigateToPromiseInfo
            .drive(with: self) { owner, promiseID in
                guard promiseID > 0 else { return }
                
                let pagePromiseViewController = PromiseViewController(
                    viewModel: PromiseViewModel(promiseID: promiseID, service: PromiseService())
                )
                
                owner.navigationController?.pushViewController(pagePromiseViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func navigateToAddPromise() {
        let viewModel = AddPromiseViewModel(meetingID: viewModel.meetingID)
        let viewController = AddPromiseViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupNavigationBarRightButton() {
        let moreButton = UIBarButtonItem(
            image: .imgMore.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(moreButtonDidTap)
        )
        
        navigationItem.rightBarButtonItem = moreButton
    }
    
    @objc
    func moreButtonDidTap() {
        let viewController = MeetingInfoMoreViewController(meetingName: viewModel.meetingName)
        viewController.delegate = self
        
        let bottomSheetController = BottomSheetViewController(
            contentViewController: viewController,
            defaultHeight: Screen.height(232)
        )
        
        present(bottomSheetController, animated: true)
    }
}


// MARK: - MeetingInfoMoreDelegate

extension MeetingInfoViewController: MeetingInfoMoreDelegate {
    func exitButtonDidTap() {
        let actionSheetController = CustomActionSheetController(kind: .exitMeeting)
        actionSheetController.delegate = self
        
        present(actionSheetController, animated: true)
    }
}


// MARK: - CustomActionSheetDelegate

extension MeetingInfoViewController: CustomActionSheetDelegate {
    func actionButtonDidTap(for kind: ActionSheetKind) {
        guard kind == .exitMeeting else { return }
        
        actionButtonDidTapRelay.accept(())
    }
}


// MARK: - MeetingMemberCellDelegate

extension MeetingInfoViewController: MeetingMemberCellDelegate {
    func profileImageViewDidTap() {
        guard let code = viewModel.meetingInvitationCode else { return }
        
        let viewController = InvitationCodePopUpViewController(
            invitationCode: code
        )
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true)
    }
}
