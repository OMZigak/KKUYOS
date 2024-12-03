//
//  MeetingListViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import RxCocoa
import RxSwift

class MeetingListViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = MeetingListView()
    
    private let viewModel: MeetingListViewModel
    private let viewWillAppearRelay = PublishRelay<Void>()
    private let meetingCellDidSelectRelay = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    
    init(viewModel: MeetingListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray0
        setupNavigationBarTitle(with: "내 모임")
        
        bindViewModel()
        register()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearRelay.accept(())
    }
    
    override func setupAction() {
        rootView.addButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.navigateToAddMeeting()
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .map { $0.item }
            .bind(to: meetingCellDidSelectRelay)
            .disposed(by: disposeBag)
    }
    
    override func setupDelegate() {
        rootView.tableView.delegate = self
    }
    
    
    // MARK: - Function
    
    private func register() {
        rootView.tableView.register(
            MeetingTableViewCell.self, forCellReuseIdentifier: MeetingTableViewCell.reuseIdentifier
        )
    }
    
    private func bindViewModel() {
        let input = MeetingListViewModel.Input(
            viewWillAppear: viewWillAppearRelay,
            meetingCellDidSelect: meetingCellDidSelectRelay
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.info
            .drive(with: self) { owner, info in
                let (userName, meetingCount) = info
                owner.configureInfo(userName: userName, meetingCount: meetingCount)
            }
            .disposed(by: disposeBag)
        
        output.info
            .map { _, meetingCount in meetingCount != 0}
            .drive(with: self) { owner, isHidden in
                owner.rootView.emptyLabel.isHidden = isHidden
                owner.rootView.emptyCharacter.isHidden = isHidden
            }
            .disposed(by: disposeBag)
        
        output.meetings
            .drive(rootView.tableView.rx.items(
                cellIdentifier: MeetingTableViewCell.reuseIdentifier,
                cellType: MeetingTableViewCell.self
            )) { index, meetingList, cell in
                cell.dataBind(meetingList)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.navigateToMeetingInfo
            .drive(with: self) { owner, meetingID in
                owner.navigateToMeetingInfo(meetingID: meetingID)
            }
            .disposed(by: disposeBag)
    }
    
    private func navigateToAddMeeting() {
        let checkInviteCodeViewController = CheckInviteCodeViewController()
        
        tabBarController?.navigationController?.pushViewController(
            checkInviteCodeViewController,
            animated: true
        )
    }
    
    private func navigateToMeetingInfo(meetingID: Int) {
        let meetingInfoViewController = MeetingInfoViewController(
            viewModel: MeetingInfoViewModel(
                meetingID: meetingID,
                service: MeetingService()
            )
        )
        
        tabBarController?.navigationController?.pushViewController(
            meetingInfoViewController,
            animated: true
        )
    }
}


// MARK: - UITableViewDelegate

extension MeetingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen.height(88)
    }
}


// MARK: - Configure

private extension MeetingListViewController {
    func configureInfo(userName: String, meetingCount: Int) {
        rootView.infoLabel.setText(
            "\(userName) 님이 가입한 모임은\n총 \(meetingCount)개예요!", 
            style: .head01,
            color: .gray8
        )
    }
}
