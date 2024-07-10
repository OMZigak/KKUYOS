//
//  ProfileViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import Foundation

class ProfileViewModel {
    
    var nickname: String = ""
    
    func setNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func getNickname() -> String {
        return nickname
    }
}
