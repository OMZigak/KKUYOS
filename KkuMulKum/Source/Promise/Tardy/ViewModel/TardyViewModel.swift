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
    var isPastDue: ObservablePattern<Bool>
    var hasTardy: ObservablePattern<Bool>
    
    
    // MARK: Initialize

    init(
        tardyService: TardyServiceType,
        isPastDue: ObservablePattern<Bool>,
        hasTardy: ObservablePattern<Bool>
    ) {
        self.tardyService = tardyService
        self.isPastDue = isPastDue
        self.hasTardy = hasTardy
    }
}
