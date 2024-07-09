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
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        addSubview(cellView)
        cellView.addSubviews(
            dateIcon,
            timeIcon,
            placeIcon,
            dDayLabel,
            meetingNameLabel,
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
