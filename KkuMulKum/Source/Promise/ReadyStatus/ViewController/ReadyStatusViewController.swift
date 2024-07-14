//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class ReadyStatusViewController: BaseViewController {
    private let rootView: ReadyStatusView = ReadyStatusView()

    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .gray0
    }
    
    override func setupDelegate() {
        rootView.ourReadyStatusTableView.delegate = self
        rootView.ourReadyStatusTableView.dataSource = self
    }
}


// MARK: UITableViewDelegate

extension ReadyStatusViewController: UITableViewDelegate {
    
}


// MARK: UITableViewDataSource

extension ReadyStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OurReadyStatusTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? OurReadyStatusTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen.height(72)
    }
}
