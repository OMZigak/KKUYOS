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
    
    private let cellView = UIView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    private let meetingNameView = UIStackView(axis: .horizontal).then {
        $0.backgroundColor = .green2
        $0.layer.cornerRadius = 12
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
    
    private let dDayLabel = UILabel()
    
    private let meetingNameLabel = UILabel()
    
    private let nameLabel = UILabel()
    
    private let dateLabel = UILabel()
    
    private let timeLabel = UILabel()
    
    private let placeNameLabel = UILabel()
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        contentView.addSubview(cellView)
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
    
    override func setupAutoLayout() {
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingNameView.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(2)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(meetingNameView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        
        dateIcon.snp.makeConstraints {
            $0.bottom.equalTo(timeIcon.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateIcon.snp.centerY)
            $0.leading.equalToSuperview().offset(48)
        }
        
        timeIcon.snp.makeConstraints {
            $0.bottom.equalTo(placeIcon.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon.snp.centerY)
            $0.leading.equalToSuperview().offset(48)
        }
        
        placeIcon.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-18)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(placeIcon.snp.centerY)
            $0.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}


// MARK: - Data Bind

extension UpcomingPromiseCollectionViewCell {
    func dataBind(_ contentData: UpcomingPromise) {
        let dDayText = contentData.dDay == 0 ? "DAY" : "\(contentData.dDay)"
        dDayLabel.setText(
            "D-\(dDayText)",
            style: .body05,
            color: contentData.dDay == 0 ? .mainorange : .gray5
        )
        meetingNameLabel.setText(contentData.meetingName, style: .caption02, color: .green3)
        nameLabel.setText(contentData.name, style: .body03, color: .gray8)
        dateLabel.setText(contentData.time, style: .body06, color: .gray7)
        timeLabel.setText(contentData.time, style: .body06, color: .gray7)
        placeNameLabel.setText(
            contentData.placeName,
            style: .body06,
            color: .gray7,
            isSingleLine: true
        )
    }
}
