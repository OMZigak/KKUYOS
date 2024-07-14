//
//  TardyViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import Foundation

class TardyViewModel {
    var isPastDue: ObservablePattern<Bool>
    var hasTardy: ObservablePattern<Bool>
    
    init(
        isPastDue: ObservablePattern<Bool>,
        hasTardy: ObservablePattern<Bool>
    ) {
        self.isPastDue = isPastDue
        self.hasTardy = hasTardy
    }
}
