//
//  HomeViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/11/24.
//

import UIKit

enum ReadyState {
    case none
    case prepare
    case move
    case arrive
}

final class HomeViewModel {
    var currentState = ObservablePattern<ReadyState>(.none)
    var contentData = ObservablePattern<[UpcomingPromiseModel]>(UpcomingPromiseModel.dummy())
    
    func updateState(newState: ReadyState) {
        currentState.value = newState
    }
    
    func updateContentData(newData: [UpcomingPromiseModel]) {
        contentData.value = newData
    }
}
