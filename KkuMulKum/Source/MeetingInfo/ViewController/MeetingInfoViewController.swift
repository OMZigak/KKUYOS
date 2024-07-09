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
        
        viewWillAppearRelay.accept(())
    }
    
    override func setupView() {
        setupNavigationBar()
    }
}

private extension MeetingInfoViewController {
    func bindViewModel() {
        let input = MeetingInfoViewModel.Input(
            viewWillAppear: viewWillAppearRelay
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
            .drive(rootView.promiseListView.rx.items(
                cellIdentifier: MeetingPromiseCell.reuseIdentifier,
                cellType: MeetingPromiseCell.self
            )) { index, promise, cell in
                cell.configure(
                    dDay: promise.dDay,
                    name: promise.name,
                    date: promise.date,
                    time: promise.time,
                    place: promise.placeName
                )
            }
            .disposed(by: disposeBag)
    }
}

extension MeetingInfoViewController: MeetingMemberCellDelegate {
    func profileImageButtonDidTap() {
        // TODO: 초대코드를 보여주는 팝업
        print(">>> \(viewModel.meetingInvitationCode) : \(#function)")
    }
}

private extension MeetingInfoViewController {
    func setupNavigationBar() {
        title = ""
        
        let navigationBar = navigationController?.navigationBar
        
        navigationBar?.do {
            $0.titleTextAttributes = [
                .foregroundColor: UIColor.gray8,
                .font: UIFont.pretendard(.body03)
            ]
            
            $0.topItem?.backButtonDisplayMode = .minimal
        }
    }
}
