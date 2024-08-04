//
//  OurReadyStatusCollectionViewCell.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/16/24.
//

import UIKit

class OurReadyStatusCollectionViewCell: BaseCollectionViewCell {
    var profileImageView: UIImageView = UIImageView(image: .imgProfile).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Screen.height(44) / 2
        $0.clipsToBounds = true
    }
    
    let nameLabel: UILabel = UILabel().then {
        $0.setText("유짐이", style: .body03, color: .gray8)
    }
    
    var readyStatusButton: ReadyStatusButton = ReadyStatusButton(
        title: "준비중",
        readyStatus: .ready
    ).then {
        $0.layer.cornerRadius = Screen.height(14)
        $0.layer.borderWidth = 0.5
    }
    
    override func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubviews(
            profileImageView,
            nameLabel,
            readyStatusButton
        )
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(Screen.height(44))
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13)
        }
        
        readyStatusButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(Screen.height(28))
            $0.width.equalTo(Screen.width(68))
        }
    }
}
