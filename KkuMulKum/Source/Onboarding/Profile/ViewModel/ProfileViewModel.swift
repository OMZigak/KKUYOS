//
//  ProfileViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class ProfileSetupViewModel {
    let profileImage = ObservablePattern<UIImage?>(UIImage.imgProfile)
    let isConfirmButtonEnabled = ObservablePattern<Bool>(false)
    let nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage.value = image
        isConfirmButtonEnabled.value = image != nil
    }
}
