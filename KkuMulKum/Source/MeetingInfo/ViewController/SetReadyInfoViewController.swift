//
//  SetReadyInfoViewController.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/14/24.
//

import UIKit

final class SetReadyInfoViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = SetReadyInfoView()
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = rootView
    }
}
