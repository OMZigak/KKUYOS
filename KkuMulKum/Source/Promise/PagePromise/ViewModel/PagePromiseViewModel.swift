//
//  PromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation


class PagePromiseViewModel {
    
    
    // MARK: Property
    
    private let service: PromiseServiceType

    let promiseID: Int
    let currentPage = ObservablePattern<Int>(0)
    let promiseInfo = ObservablePattern<PromiseInfoModel?>(nil)
    let promiseName: String = "Test"
    
    
    // MARK: Initialize

    init(promiseID: Int, service: PromiseServiceType) {
        self.service = service
        self.promiseID = promiseID
    }
}


// MARK: - Extension

extension PagePromiseViewModel {
    func segmentIndexDidChanged(index: Int) {
        currentPage.value = index
    }
    
    func fetchPromiseInfo(promiseID: Int) {
        Task {
            do {
                let result = try await service.fetchPromiseInfo(with: promiseID)
                
                guard let success = result?.success,
                        success == true
                else {
                    return
                }
                
                promiseInfo.value = result?.data
            }
        }
    }
}
