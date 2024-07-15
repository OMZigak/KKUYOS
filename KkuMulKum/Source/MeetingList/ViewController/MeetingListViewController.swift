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
    private let viewModel = MeetingListViewModel()
    
    
    // MARK: - Initializer
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray0
        setupNavigationBarTitle(with: "내 모임")
        register()
        
        updateMeetingList()
        viewModel.dummy()
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
        viewModel.meetingListData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.rootView.tableView.reloadData()
            }
        }
    }
}

extension MeetingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen.height(88)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = MeetingInfoViewController(
            viewModel: MeetingInfoViewModel(
                meetingID: 1,
                service: MockMeetingInfoService()
            )
        )
        
        tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MeetingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meetingListData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rootView.tableView.dequeueReusableCell(
            withIdentifier: MeetingTableViewCell.reuseIdentifier, for: indexPath
        ) as? MeetingTableViewCell else { return UITableViewCell() }
        cell.dataBind(viewModel.meetingListData.value[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let basePromiseViewController = PagePromiseViewController()
        
        basePromiseViewController.modalPresentationStyle = .fullScreen
        
        // TODO: 추후 네비게이션 여부 정해지면 맞춰서 수정
        present(basePromiseViewController, animated: false)
    }
}
