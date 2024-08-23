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
    }
    
    override func setupAction() {
        rootView.createPromiseButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.navigateToAddPromise()
            }
            .disposed(by: disposeBag)
    }
    
    override func setupDelegate() {
        rootView.promiseListView.delegate = self
    }
}


// MARK: - UICollectionViewDelegate

extension MeetingInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pagePromiseViewController = PromiseViewController(
            viewModel: PromiseViewModel(
                promiseID: viewModel.meetingPromises[indexPath.item].promiseID, 
                service: PromiseService()
            )
        )
        
        navigationController?.pushViewController(pagePromiseViewController, animated: true)
    }
}

private extension MeetingInfoViewController {
    func bindViewModel() {
        let input = MeetingInfoViewModel.Input(
            viewWillAppear: viewWillAppearRelay,
            createPromiseButtonDidTap: rootView.createPromiseButtonDidTap
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.info
            .drive(with: self) { owner, meetingInfo in
                guard let info = meetingInfo else { return }
                owner.title = info.name
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
    }
    
    func navigateToAddPromise() {
        let viewModel = AddPromiseViewModel(meetingID: viewModel.meetingID)
        let viewController = AddPromiseViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - MeetingMemberCellDelegate

extension MeetingInfoViewController: MeetingMemberCellDelegate {
    func profileImageButtonDidTap() {
        guard let code = viewModel.meetingInvitationCode else { return }
        
        let viewController = InvitationCodePopUpViewController(
            invitationCode: code
        )
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true)
    }
}
