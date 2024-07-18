//
//  MeetingListViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import SnapKit

class MeetingListViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = MeetingListView()
    
    private let viewModel: MeetingListViewModel
    
    
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
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray0
        setupNavigationBarTitle(with: "내 모임")
        register()
        
        updateMeetingList()
        viewModel.requestMeetingList()
    }
    
    override func setupAction() {
        rootView.addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    
    // MARK: - Function
    
    private func register() {
        rootView.tableView.register(
            MeetingTableViewCell.self, forCellReuseIdentifier: MeetingTableViewCell.reuseIdentifier
        )
    }
    
    override func setupDelegate() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
    
    private func updateMeetingList() {
        viewModel.meetingList.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let data = self.viewModel.meetingList.value
                
                self.rootView.infoLabel.setText(
                    "꾸물리안이 가입한 모임은\n총 \(self.viewModel.meetingList.value?.data?.count ?? 0)개예요!",
                    style: .head01,
                    color: .gray8
                )
                
                if data?.data?.count == 0 {
                    self.rootView.emptyLabel.isHidden = false
                    self.rootView.emptyCharacter.isHidden = false
                } else {
                    self.rootView.tableView.reloadData()
                }
            }
        }
    }
}


// MARK: - Extension

extension MeetingListViewController {
    @objc
    func addButtonDidTap() {
        let checkInviteCodeViewController = CheckInviteCodeViewController()
        
        tabBarController?.navigationController?.pushViewController(
            checkInviteCodeViewController,
            animated: true
        )
    }
}

// MARK: - UITableViewDelegate

extension MeetingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen.height(88)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = MeetingInfoViewController(
            viewModel: MeetingInfoViewModel(
                meetingID: viewModel.meetingList.value?.data?.meetings[indexPath.item].meetingID ?? 0,
                service: MeetingService()
            )
        )
        tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension MeetingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meetingList.value?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rootView.tableView.dequeueReusableCell(
            withIdentifier: MeetingTableViewCell.reuseIdentifier, for: indexPath
        ) as? MeetingTableViewCell else { return UITableViewCell() }
        if let data = viewModel.meetingList.value?.data?.meetings[indexPath.item] {
            cell.dataBind(data)
        }
        cell.selectionStyle = .none
        return cell
    }
}
