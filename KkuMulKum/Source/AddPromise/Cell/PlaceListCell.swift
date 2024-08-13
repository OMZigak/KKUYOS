//
//  PlaceListCell.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class PlaceListCell: BaseCollectionViewCell {
    static let defaultWidth = Screen.width(335)
    static let defaultHeight = Screen.height(118)
    
    private let titleLabel = UILabel().then {
        $0.setText(style: .body05, color: .gray8)
    }
    
    private let roadAddressTitleLabel = UILabel().then {
        $0.setText("도로명", style: .label01, color: .gray6)
        $0.textAlignment = .center
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let roadAddressNameLabel = UILabel().then {
        $0.setText(style: .caption02, color: .gray6, isSingleLine: true)
    }
    
    private let addressTitleLabel = UILabel().then {
        $0.setText("지번", style: .label01, color: .gray6)
        $0.textAlignment = .center
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let addressNameLabel = UILabel().then {
        $0.setText(style: .caption02, color: .gray6, isSingleLine: true)
    }
    
    
    // MARK: - Property

    override var isSelected: Bool {
        didSet {
            let color: UIColor = isSelected ? .maincolor : .gray3
            layer.borderColor = color.cgColor
        }
    }
    
    private(set) var place: Place?
    
    override func setupView() {
        self.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.gray3.cgColor
            $0.layer.borderWidth = 1
        }
        
        contentView.addSubviews(
            titleLabel,
            roadAddressTitleLabel,
            roadAddressNameLabel,
            addressTitleLabel,
            addressNameLabel
        )
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
        }
        
        roadAddressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Screen.width(38))
            $0.height.equalTo(Screen.height(24))
        }
        
        roadAddressNameLabel.snp.makeConstraints {
            $0.leading.equalTo(roadAddressTitleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(roadAddressTitleLabel)
        }
        
        addressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(roadAddressTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(Screen.width(38))
            $0.height.equalTo(Screen.height(24))
        }
        
        addressNameLabel.snp.makeConstraints {
            $0.leading.equalTo(addressTitleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(addressTitleLabel)
        }
    }
}

extension PlaceListCell {
    func configure(place: Place) {
        self.place = place
        
        configureCell(title: place.location, roadAddress: place.roadAddress, address: place.address)
    }
}

private extension PlaceListCell {
    func configureCell(title: String, roadAddress: String?, address: String?) {
        titleLabel.updateText(title)
        roadAddressNameLabel.updateText(roadAddress)
        addressNameLabel.updateText(address)
    }
}
