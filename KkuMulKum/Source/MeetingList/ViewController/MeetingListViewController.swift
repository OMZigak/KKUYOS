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
                self?.rootView.tableView.reloadData()
                self?.rootView.infoLabel.setText(
                    "꾸물리안이 가입한 모임은\n총 \(self?.viewModel.meetingList.value?.count ?? 0)개예요!",
                    style: .head01,
                    color: .gray8
                )
            }
        }
    }
}


// MARK: - UITableViewDelegate

extension MeetingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen.height(88)
    }
}


// MARK: - UITableViewDataSource

extension MeetingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meetingList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rootView.tableView.dequeueReusableCell(
            withIdentifier: MeetingTableViewCell.reuseIdentifier, for: indexPath
        ) as? MeetingTableViewCell else { return UITableViewCell() }
        if let data = viewModel.meetingList.value?.meetings[indexPath.item] {
            cell.dataBind(data)
        }
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
