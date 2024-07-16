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
}


// MARK: - Extension

extension PagePromiseViewModel {
    func didSegmentIndexChanged(index: Int) {
        currentPage.value = index
    }
}
