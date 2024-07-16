//
//  ParticipantCollectionViewCell.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

import SnapKit

class ParticipantCollectionViewCell: BaseCollectionViewCell {
    
    
    // MARK: Property

    private lazy var profileImageView: UIImageView = UIImageView().then {
        $0.image = .imgProfile
        $0.contentMode = .scaleAspectFit
    }
    
    private let userNameLabel: UILabel = UILabel().then {
        $0.setText("userName", style: .caption02, color: .gray6)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        contentView.addSubviews(profileImageView, userNameLabel)
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(68))
            $0.width.equalTo(profileImageView.snp.height)
            $0.top.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(6)
            $0.centerX.equalTo(profileImageView)
            $0.bottom.equalToSuperview()
        }
    }
}
