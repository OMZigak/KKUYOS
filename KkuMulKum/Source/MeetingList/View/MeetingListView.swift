//
//  MeetingListView.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/12/24.
//

import UIKit

import SnapKit
import Then

final class MeetingListView: BaseView {
    
    
    // MARK: - Property
    
    private let topBackgroundView = UIView(backgroundColor: .white)
    
    private let header = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Screen.height(174))
    }
    
    let infoLabel = UILabel()
    
    private let addButtonView = UIView(backgroundColor: .green2).then {
        $0.layer.cornerRadius = 8
    }
    
    let addButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
    }
    
    private let addInfoView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let addInfoLabel = UILabel().then {
        $0.setText("모임 추가하기", style: .body05, color: .green3)
    }
    
    private let addIconImageView = UIImageView().then {
        $0.image = .iconGroupPlus
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.tableHeaderView = header
    }
    
    let emptyCharacter = UIImageView().then {
        $0.image = .imgEmpty
        $0.isHidden = true
    }
    
    let emptyLabel = UILabel().then {
        $0.setText("아직 모임이 없네요!\n모임을 추가해 보세요.", style: .body05, color: .gray4)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    
    // MARK: - UI Setting
    
    override func setupView() {
        self.backgroundColor = .gray0
        addSubviews(topBackgroundView, tableView, emptyCharacter, emptyLabel)
        header.addSubviews(infoLabel, addButtonView, addInfoView, addButton)
        addInfoView.addArrangedSubviews(addIconImageView, addInfoLabel)
    }
    
    override func setupAutoLayout() {
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview()
        }
        
        addButtonView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(48))
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(48))
        }
        
        emptyCharacter.snp.makeConstraints {
            $0.top.equalTo(addButton.snp.bottom).offset(94)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Screen.height(174))
            $0.width.equalTo(Screen.width(100))
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyCharacter.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        addInfoView.snp.makeConstraints {
            $0.centerY.equalTo(addButton.snp.centerY)
            $0.centerX.equalTo(addButton.snp.centerX)
        }
    }
}
