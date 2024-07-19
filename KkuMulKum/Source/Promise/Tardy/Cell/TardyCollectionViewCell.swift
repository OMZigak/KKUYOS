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
        addSubviews(profileImageView, nameLabel)
        
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray2.cgColor
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13.5)
            $0.leading.trailing.equalToSuperview().inset(18.5)
            $0.height.equalTo(Screen.height(67))
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16.5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(19)
        }
    }
}
