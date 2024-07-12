//
//  GroupListViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import SnapKit

class MeetingListViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = MeetingListView()
    
    private var meetingList: [MeetingDummyModel] = MeetingDummyModel.dummy() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.rootView.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Initializer
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray0
        setupView()
        register()
        setupDelegate()
    }
    
    
    // MARK: - Function
    
    override func setupView() {
        setupNavigationBar()
    }
    
    private func register() {
        rootView.tableView.register(
            MeetingTableViewCell.self, forCellReuseIdentifier: MeetingTableViewCell.reuseIdentifier
        )
    }
    
    override func setupDelegate() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }


    // MARK: - Function
    
     private func setupNavigationBar() {
        title = "내 모임"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.gray8,
            .font: UIFont.pretendard(.body03)
        ]
    }
}

extension MeetingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension MeetingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rootView.tableView.dequeueReusableCell(
            withIdentifier: MeetingTableViewCell.reuseIdentifier, for: indexPath
        ) as? MeetingTableViewCell else { return UITableViewCell() }
        cell.dataBind(meetingList[indexPath.item], itemRow: indexPath.item)
        cell.selectionStyle = .none
        return cell
    }
}
