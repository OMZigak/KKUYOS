//
//  OurReadyStatusTableViewCell.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import UIKit

class OurReadyStatusTableViewCell: BaseTableViewCell {
    private let profileImageView: UIImageView = UIImageView(image: .imgProfile).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel: UILabel = UILabel().then {
        $0.setText("유짐이", style: .body03, color: .gray8)
    }
    
    private let readyStatusButton: ReadyStatusButton = ReadyStatusButton(
        title: "준비중",
        readyStatus: .ready
    )
    
    override func setupView() {
        addSubviews(profileImageView, nameLabel, readyStatusButton)
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(Screen.height(44))
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13)
        }
        
        readyStatusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(Screen.height(28))
            $0.width.equalTo(Screen.width(68))
        }
    }
}
