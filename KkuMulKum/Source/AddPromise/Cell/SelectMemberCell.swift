//
//  SelectMemberCell.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

import Kingfisher

final class SelectMemberCell: BaseCollectionViewCell {
    private let profileImageView: UIImageView = UIImageView().then {
        $0.image = .imgProfile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Screen.height(67) / 2
        $0.clipsToBounds = true
    }
    
    private let nameLabel: UILabel = UILabel().then {
        $0.setText("이름", style: .body06, color: .gray6)
    }
    
    
    // MARK: - Property
    
    private(set) var member: Member?
    
    override var isSelected: Bool {
        didSet {
            let color: UIColor = isSelected ? .maincolor : .gray2
            layer.borderColor = color.cgColor
        }
    }
    
    override func setupView() {
        addSubviews(profileImageView, nameLabel)
        
        self.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.gray2.cgColor
            $0.layer.borderWidth = 1
        }
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

extension SelectMemberCell {
    func configure(with member: Member) {
        self.member = member
        
        nameLabel.setText(member.name ?? " ", style: .body06, color: .gray6)
        
        let imageURL = member.profileImageURL.flatMap { URL(string: $0) }
        profileImageView.kf.setImage(with: imageURL, placeholder: UIImage.imgProfile.withRenderingMode(.alwaysOriginal))
    }
}
