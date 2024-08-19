//
//  ParticipantCollectionViewCell.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

import SnapKit

class ParticipantCollectionViewCell: BaseCollectionViewCell {
    
    
    // MARK: - Property

    let profileImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .gray1
        $0.image = .imgProfile
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = Screen.height(64) / 2
        $0.clipsToBounds = true
    }
    
    let userNameLabel: UILabel = UILabel().then {
        $0.setText("꾸물이", style: .caption02, color: .gray6)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        contentView.addSubviews(profileImageView, userNameLabel)
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(64))
            $0.width.equalTo(profileImageView.snp.height)
            $0.top.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(profileImageView)
            $0.bottom.equalToSuperview()
        }
    }
}
