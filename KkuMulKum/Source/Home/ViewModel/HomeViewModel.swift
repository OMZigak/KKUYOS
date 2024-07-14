//
//  HomeViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/11/24.
//

import UIKit

import Then

enum ReadyState {
    case none
    case prepare
    case move
    case arrive
}

final class HomeViewModel {
    var currentState = ObservablePattern<ReadyState>(.none)
    var upcomingPromiseData = ObservablePattern<[UpcomingPromiseModel]>([])
    
    var homePrepareTime: String = ""
    var homeMoveTime: String = ""
    var homeArriveTime: String = ""
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "a hh:mm"
        $0.amSymbol = "AM"
        $0.pmSymbol = "PM"
    }
    
    func updateState(newState: ReadyState) {
        currentState.value = newState
        let currentTimeString = dateFormatter.string(from: Date())
        switch newState {
        case .prepare:
            homePrepareTime = currentTimeString
        case .move:
            homeMoveTime = currentTimeString
        case .arrive:
            homeArriveTime = currentTimeString
        case .none:
            break
        }
    }
    
    /// 더미 함수 이후에 삭제
    func dummy() {
        upcomingPromiseData.value = UpcomingPromiseModel.dummy()
    }
    
    func updateContentData(newData: [UpcomingPromiseModel]) {
        upcomingPromiseData.value = newData
    }
}
