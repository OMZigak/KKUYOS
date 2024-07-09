//
//  ParticipantCollectionViewCell.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

import SnapKit

class ParticipantCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var profileButton: UIButton = UIButton().then {
        $0.setImage(.imgProfile, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    private let userNameLabel: UILabel = UILabel().then {
        $0.setText("dddd", style: .caption02)
    }
    
    override func setupView() {
        contentView.addSubviews(profileButton, userNameLabel)
    }
    
    override func setupAutoLayout() {
        profileButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(4)
            $0.centerX.equalTo(profileButton)
            $0.bottom.equalToSuperview()
        }
    }
}
