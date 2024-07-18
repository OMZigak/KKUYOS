//
//  PromiseInfoViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/17/24.
//

import Foundation

class PromiseInfoViewModel {
    var promiseID: ObservablePattern<Int>
    var promiseInfoService: PromiseInfoServiceType
    
    init(promiseInfoService: PromiseInfoServiceType, promiseID: Int) {
        self.promiseInfoService = promiseInfoService
        self.promiseID = ObservablePattern<Int>(promiseID)
    }
}
