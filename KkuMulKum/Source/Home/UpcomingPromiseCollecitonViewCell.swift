//
//  UpcomingPromiseCollecitonViewCell.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/10/24.
//

import UIKit

import SnapKit
import Then


final class UpcomingPromiseCollectionViewCell: BaseCollectionViewCell {
    
    
    // MARK: - Property
    
    var itemRow: Int?
    
    private let cellView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    private let meetingNameView = UIStackView().then {
        $0.backgroundColor = .green2
        $0.layer.cornerRadius = 12
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let dateIcon = UIImageView().then {
        $0.image = .iconDate
    }
    
    private let timeIcon = UIImageView().then {
        $0.image = .iconTime
    }
    
    private let placeIcon = UIImageView().then {
        $0.image = .iconPin
    }
    
    private let dDayLabel = UILabel().then {
        $0.textColor = .gray5
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body05)
    }
    
    private let meetingNameLabel = UILabel().then {
        $0.textColor = .green3
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.caption02)
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .gray8
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body03)
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray7
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body06)
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .gray7
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body06)
    }
    
    private let placeNameLabel = UILabel().then {
        $0.textColor = .gray7
        $0.textAlignment = .left
        $0.font = UIFont.pretendard(.body06)
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubview(cellView)
        meetingNameView.addSubview(meetingNameLabel)
        cellView.addSubviews(
            dateIcon,
            timeIcon,
            placeIcon,
            dDayLabel,
            meetingNameView,
            nameLabel,
            dateLabel,
            timeLabel,
            placeNameLabel
        )
    }
    
    override func setupAction() {
        
    }
    
    override func setupAutoLayout() {
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingNameView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.leading.equalToSuperview().offset(16)
        }
        
        dateIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateIcon.snp.centerY)
            $0.leading.equalToSuperview().offset(48)
        }
        
        timeIcon.snp.makeConstraints {
            $0.top.equalTo(dateIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon.snp.centerY)
            $0.leading.equalToSuperview().offset(48)
        }
        
        placeIcon.snp.makeConstraints {
            $0.top.equalTo(timeIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(placeIcon.snp.centerY)
            $0.leading.equalToSuperview().offset(48)
        }
    }
}


// MARK: - Data Bind

extension UpcomingPromiseCollectionViewCell {
    func dataBind(_ contentData: UpcomingPromiseModel, itemRow: Int) {
        self.itemRow = itemRow
        dDayLabel.text = "D-\(contentData.dDay)"
        meetingNameLabel.text = contentData.meetingName
        nameLabel.text = contentData.name
        dateLabel.text = contentData.date
        timeLabel.text = contentData.time
        placeNameLabel.text = contentData.placeName
    }
}
