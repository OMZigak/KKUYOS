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
    private let titleLabel = UILabel().then {
        $0.setText("", style: .body05, color: .gray8)
    }
    
    private let roadAddressView = UIView(backgroundColor: .gray0).then {
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let roadAddressLabel = UILabel().then {
        $0.setText("도로명", style: .label01, color: .gray6)
    }
    
    private let roadAddressNameLabel = UILabel().then {
        $0.setText(" ", style: .caption02, color: .gray6)
    }
    
    private let roadAddressStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 8
    }
    
    private let addressView = UIView(backgroundColor: .gray0).then {
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let addressLabel = UILabel().then {
        $0.setText("지번", style: .label01, color: .gray6)
    }
    
    private let addressNameLabel = UILabel().then {
        $0.setText("", style: .caption02, color: .gray6)
    }
    
    private let addressStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 8
    }
    
    private let contentStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 8
    }
    
    
    // MARK: - Property

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = 
            isSelected ? UIColor.maincolor.cgColor : UIColor.gray3.cgColor
        }
    }
    
    private(set) var place: Place?
    
    override func setupView() {
        contentView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.gray3.cgColor
            $0.layer.borderWidth = 1
        }
        
        roadAddressView.addSubviews(roadAddressLabel)
        roadAddressStackView.addArrangedSubviews(roadAddressView, roadAddressNameLabel)
        
        addressView.addSubviews(addressLabel)
        addressStackView.addArrangedSubviews(addressView, addressNameLabel)
        
        contentStackView.addArrangedSubviews(titleLabel, roadAddressStackView, addressStackView)
        contentView.addSubviews(contentStackView)
    }
    
    override func setupAutoLayout() {
        roadAddressLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(5)
        }
        
        addressLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
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
        titleLabel.setText(title, style: .body05, color: .gray8)
        roadAddressNameLabel.setText(roadAddress ?? " ", style: .caption02, color: .gray6)
        addressNameLabel.setText(address ?? " ", style: .caption02, color: .gray6)
    }
}
