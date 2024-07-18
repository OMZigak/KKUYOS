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
    
    
    // MARK: Initialize

    init(promiseID: ObservablePattern<Int>) {
        self.promiseID = promiseID
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
