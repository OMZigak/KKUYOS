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
    private let viewModel = MeetingListViewModel()
    
    
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
        
        updateMeetingList()
        viewModel.dummy()
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
    
    private func updateMeetingList() {
        viewModel.meetingListData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.rootView.tableView.reloadData()
            }
        }
    }


    // MARK: - Function
    
     private func setupNavigationBar() {
        title = "내 모임"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.gray8,
            .font: UIFont.pretendard(.body03)
        ]
         
         let lineView = UIView(backgroundColor: .gray2)
         navigationController?.navigationBar.addSubview(lineView)
         
         lineView.snp.makeConstraints {
             $0.leading.trailing.equalToSuperview()
             $0.bottom.equalTo(navigationController?.navigationBar.snp.bottom ?? 0)
             $0.height.equalTo(Screen.height(1))
         }
     }
}

extension MeetingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
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
}
