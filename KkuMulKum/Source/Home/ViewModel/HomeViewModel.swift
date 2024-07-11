//
//  HomeViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/11/24.
//

import UIKit

enum ReadyStatus {
    case none
    case prepare
    case move
    case arrive
}

final class HomeViewModel {
    private var currentStatus: ReadyStatus = .none
    
    func updateStatus(currentStatus: ReadyStatus) {
        
    }
    
}
