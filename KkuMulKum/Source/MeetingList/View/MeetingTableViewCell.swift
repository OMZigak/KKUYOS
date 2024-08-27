//
//  MeetingViewCell.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class MeetingTableViewCell: BaseTableViewCell {
    
    
    // MARK: - Property
    
    private let cellView = UIView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
    }
    
    private let nameLabel = UILabel()
    
    private let countLabel = UILabel()
    
    private let rightIcon = UIImageView().then {
        $0.image = .iconRight.withTintColor(.gray3)
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        self.backgroundColor = .clear
        addSubviews(cellView, nameLabel, countLabel, rightIcon)
    }
    
    override func setupAutoLayout() {
        cellView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(76))
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalTo(cellView.snp.bottom).offset(-16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        rightIcon.snp.makeConstraints {
            $0.centerY.equalTo(cellView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}


// MARK: - Data Bind

extension MeetingTableViewCell {
    func dataBind(_ contentData: Meeting) {
        nameLabel.setText(contentData.name, style: .body03, color: .gray8)
        countLabel.setText("\(contentData.memberCount)명 참여 중", style: .caption02, color: .gray5)
    }
}
