//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class ReadyStatusViewController: BaseViewController {
    
    
    // MARK: Property

    private let readyStatusView: ReadyStatusView = ReadyStatusView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(readyStatusView)
    }
}
