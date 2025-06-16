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
    func profileImageViewDidTap()
}

final class MeetingMemberCell: BaseCollectionViewCell {
    private let profileImageView: UIImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = Screen.height(64) / 2
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.setText(style: .caption02, color: .gray6)
        $0.textAlignment = .center
    }
    
    private weak var delegate: MeetingMemberCellDelegate?
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewDidTap(_:)))
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        profileImageView.removeGestureRecognizer(tapGesture)
        
        nameLabel.setText(style: .caption02, color: .gray6)
    }
    
    override func setupView() {
        contentView.addSubviews(profileImageView, nameLabel)
    }
    
    override func setupAutoLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(64))
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(profileImageView)
            $0.bottom.equalToSuperview()
        }
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
        
        profileImageView.do {
            $0.image = .iconPlusDark.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .center
            $0.backgroundColor = .gray1
        }
        profileImageView.addGestureRecognizer(tapGesture)
        
        nameLabel.setText(style: .caption02, color: .gray6)
    }
    
    func configureForProfile(with member: Member) {
        let name = member.name
        let imageURL = member.profileImageURL.flatMap { URL(string: $0) }
        
        nameLabel.setText(name ?? " ", style: .caption02, color: .gray6)
        
        profileImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(resource: .imgProfile).withRenderingMode(.alwaysOriginal)
        )
        profileImageView.contentMode = .scaleAspectFill
    }
    
    @objc
    func profileImageViewDidTap(_ sender: UIImageView) {
        delegate?.profileImageViewDidTap()
    }
}
