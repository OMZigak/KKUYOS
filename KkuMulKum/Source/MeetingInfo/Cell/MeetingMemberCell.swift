//
//  MeetingMemberCell.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

protocol MeetingMemberCellDelegate: AnyObject {
    func profileImageButtonDidTap()
}

final class MeetingMemberCell: BaseCollectionViewCell {
    private let profileImageButton = UIButton().then {
        $0.layer.cornerRadius = Screen.height(64) / 2
        $0.isEnabled = false
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.setText(style: .caption02, color: .gray6)
        $0.textAlignment = .center
    }
    
    private weak var delegate: MeetingMemberCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            $0.imageView?.image = nil
            $0.backgroundColor = .clear
            $0.isEnabled = false
        }
        
        nameLabel.setText(style: .caption02, color: .gray6)
    }
    
    override func setupView() {
        contentView.addSubviews(profileImageButton, nameLabel)
    }
    
    override func setupAutoLayout() {
        profileImageButton.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(64))
            $0.width.equalTo(profileImageButton.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(4)
            $0.centerX.equalTo(profileImageButton)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupAction() {
        profileImageButton.addTarget(
            self,
            action: #selector(profileImageButtonDidTap(_:)),
            for: .touchUpInside
        )
    }
}

extension MeetingMemberCell {
    enum CellState {
        case add(delegate: MeetingMemberCellDelegate)
        case profile(member: Member)
    }
    
    func configure(with state: CellState) {
        switch state {
        case .add(let delegate):
            configureForAdd(with: delegate)
        case .profile(let member):
            configureForProfile(with: member)
        }
    }
}

private extension MeetingMemberCell {
    func configureForAdd(with delegate: MeetingMemberCellDelegate) {
        self.delegate = delegate
        
        profileImageButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
            
            $0.configuration = config
            $0.backgroundColor = .gray1
            $0.setImage(.iconPlus.withTintColor(.gray4), for: .normal)
            $0.isEnabled = true
        }
        
        nameLabel.setText(style: .caption02, color: .gray6)
    }
    
    func configureForProfile(with member: Member) {
        let name = member.name
        let imageURL = member.profileImageURL.flatMap { URL(string: $0) }
        
        nameLabel.setText(name ?? " ", style: .caption02, color: .gray6)
        
        profileImageButton.kf.setImage(
            with: imageURL,
            for: .disabled,
            placeholder: .imgProfile.withRenderingMode(.alwaysOriginal)
        )
    }
    
    @objc
    func profileImageButtonDidTap(_ sender: UIButton) {
        delegate?.profileImageButtonDidTap()
    }
}
