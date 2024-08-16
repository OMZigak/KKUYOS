//
//  MeetingPromiseCell.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class MeetingPromiseCell: BaseCollectionViewCell {
    private let dDayLabel = UILabel().then {
        $0.setText(style: .body05, color: .mainorange)
    }
    
    private let nameLabel = UILabel().then {
        $0.setText("약속명", style: .body03, color: .gray8)
    }
    
    private let dateIconView = UIImageView().then {
        let image = UIImage(resource: .iconDate).withTintColor(.gray2)
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    private let dateLabel = UILabel().then {
        $0.setText(style: .body06, color: .gray7)
    }
    
    private let dateStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 8
    }
    
    private let timeIconView = UIImageView().then {
        let image = UIImage(resource: .iconTime).withTintColor(.gray2)
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    private let timeLabel = UILabel().then {
        $0.setText(style: .body06, color: .gray7)
    }
    
    private let timeStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 8
    }
    
    private let placeIconView = UIImageView().then {
        let image = UIImage(resource: .iconPin).withTintColor(.gray2)
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    private let placeLabel = UILabel().then {
        $0.setText(style: .body06, color: .gray7)
    }
    
    private let placeStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 8
    }
    
    private let contentStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 8
        $0.distribution = .equalSpacing
    }
    
    override func setupView() {
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray2.cgColor
        }
        
        dateStackView.addArrangedSubviews(dateIconView, dateLabel)
        timeStackView.addArrangedSubviews(timeIconView, timeLabel)
        placeStackView.addArrangedSubviews(placeIconView, placeLabel)
        contentStackView.addArrangedSubviews(
            dDayLabel, nameLabel, dateStackView, timeStackView, placeStackView
        )
        contentView.addSubviews(contentStackView)
    }
    
    override func setupAutoLayout() {
        dateIconView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(dateIconView.snp.height)
        }
        
        timeIconView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(timeIconView.snp.height)
        }
        
        placeIconView.snp.makeConstraints {
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(placeIconView.snp.height)
        }
        
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension MeetingPromiseCell {
    func configure(dDay: Int, name: String, date: String, time: String, place: String) {
        let dDayText = dDay == 0 ? "DAY" : "\(dDay)"
        dDayLabel.setText("D-\(dDayText)", style: .body05, color: dDay == 0 ? .mainorange : .gray5)
        nameLabel.updateText(name)
        dateLabel.updateText(date)
        timeLabel.updateText(time)
        placeLabel.updateText(place)
    }
}
