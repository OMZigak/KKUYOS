//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class ReadyStatusViewController: BaseViewController {
    private let rootView: ReadyStatusView = ReadyStatusView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(rootView)
    }
}
