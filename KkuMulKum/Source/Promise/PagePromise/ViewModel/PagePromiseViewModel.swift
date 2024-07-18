//
//  PromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation


class PagePromiseViewModel {
    
    
    // MARK: Property

    var currentPage = ObservablePattern<Int>(0)
    var promiseID: ObservablePattern<Int>
    let promiseName: String = "Test"
    
    
    // MARK: Initialize

    init(promiseID: Int) {
        self.promiseID = ObservablePattern<Int>(promiseID)
    }
}


// MARK: - Extension

extension PagePromiseViewModel {
    func segmentIndexDidChanged(index: Int) {
        currentPage.value = index
    }
    
    func promiseIDDidChanged(id: Int) {
        promiseID.value = id
    }
}
