//
//  TardyViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import Foundation

class TardyViewModel {
    
    
    // MARK: Property

    let tardyService: TardyServiceType
    var isPastDue: ObservablePattern<Bool> = ObservablePattern<Bool>(true)
    var hasTardy: ObservablePattern<Bool> = ObservablePattern<Bool>(true)
    var isFinishButtonEnabled: ObservablePattern<Bool> = ObservablePattern<Bool>(true)
    let promiseID: ObservablePattern<Int>
    
    
    // MARK: Initialize

    init(
        tardyService: TardyServiceType,
        promiseID: Int
    ) {
        self.tardyService = tardyService
        self.promiseID = ObservablePattern<Int>(promiseID)
    }
}
