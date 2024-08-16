//
//  TardyCollectionViewCell.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import UIKit

class TardyCollectionViewCell: BaseCollectionViewCell {
    
    
    // MARK: Property

    let profileImageView: UIImageView = UIImageView().then {
        $0.image = .imgProfile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Screen.height(67) / 2
        $0.clipsToBounds = true
    }
    
    let nameLabel: UILabel = UILabel().then {
        $0.setText("이름", style: .body06, color: .gray6)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        addSubviews(
            profileImageView,
            nameLabel
        )
        
        layer.cornerRadius = Screen.height(8)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray2.cgColor
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13.5)
            $0.leading.trailing.equalToSuperview().inset(18.5)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(13.5)
        }
    }
}
