//
//  ReadyStatusView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class ReadyStatusView: BaseView {
    private let baseStackView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 24
    }
    
    private let enterReadyButtonView: EnterReadyInfoButtonView = EnterReadyInfoButtonView()
    
    private let readyPlanInfoView: ReadyPlanInfoView = ReadyPlanInfoView()
    
    private let myReadyStatusTitleLabel: UILabel = UILabel().then {
        $0.setText("나의 준비 현황", style: .body01, color: .gray8)
    }
    
    private let myReadyStatusProgressView: ReadyStatusProgressView = ReadyStatusProgressView()
    
    private let popUpImageView: UIImageView = UIImageView(image: .imgTextPopup).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let ourReadyStatusLabel: UILabel = UILabel().then {
        $0.setText(
            "우리들의 준비 현황",
            style: .body01,
            color: .gray8
        )
    }
    
    private let ourReadyStatusTableView: UITableView = UITableView().then {
        $0.register(OurReadyStatusTableViewCell.self, forCellReuseIdentifier: OurReadyStatusTableViewCell.reuseIdentifier)
    }
    
    override func setupView() {
        baseStackView.addArrangedSubviews(
            enterReadyButtonView,
            readyPlanInfoView,
            myReadyStatusTitleLabel,
            myReadyStatusProgressView,
            popUpImageView,
            ourReadyStatusLabel
        )
        
        addSubview(baseStackView)
    }
    
    override func setupAutoLayout() {
        baseStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
