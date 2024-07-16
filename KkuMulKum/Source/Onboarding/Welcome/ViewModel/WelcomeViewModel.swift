//
//  WelcomeVIewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import Foundation

class WelcomeViewModel {
    let nickname: ObservablePattern<String>
    
    init(nickname: String) {
        self.nickname = ObservablePattern(nickname)
    }
}
