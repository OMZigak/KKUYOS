//
//  PromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation


class PagePromiseViewModel {
    var currentPage = ObservablePattern<Int>(0)
    
    func didSegmentIndexChanged(index: Int) {
        currentPage.value = index
    }
}
