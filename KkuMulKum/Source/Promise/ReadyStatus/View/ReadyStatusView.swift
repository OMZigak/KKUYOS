//
//  ReadyStatusView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class ReadyStatusView: BaseView {
    private var ourReadyStatusViews: [OurReadyStatusView] = [
        OurReadyStatusView(),
        OurReadyStatusView(),
        OurReadyStatusView(),
        OurReadyStatusView(),
        OurReadyStatusView()
    ]
    
    private let scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView: UIView = UIView()
    
    private let baseStackView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 24
        $0.backgroundColor = .gray0
    }
    
    private let enterReadyButtonView: EnterReadyInfoButtonView = EnterReadyInfoButtonView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let readyPlanInfoView: ReadyPlanInfoView = ReadyPlanInfoView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let myReadyStatusTitleLabel: UILabel = UILabel().then {
        $0.setText("나의 준비 현황", style: .body01, color: .gray8)
    }
    
    private let readyBaseView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 4
    }
    
    private let myReadyStatusProgressView: ReadyStatusProgressView = ReadyStatusProgressView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
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
    
    let ourReadyStatusStackView: UIStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 8
    }
    
    let ourReadyStatusTableView: UITableView = UITableView().then {
        $0.register(
            OurReadyStatusTableViewCell.self,
            forCellReuseIdentifier: OurReadyStatusTableViewCell.reuseIdentifier
        )
        $0.backgroundColor = .clear
    }
    
    override func setupView() {
        ourReadyStatusViews.forEach {
            ourReadyStatusStackView.addArrangedSubview($0)
        }
        
        readyBaseView.addArrangedSubviews(
            myReadyStatusProgressView,
            popUpImageView
        )
        
        baseStackView.addArrangedSubviews(
            enterReadyButtonView,
            readyPlanInfoView,
            myReadyStatusTitleLabel,
            readyBaseView,
            ourReadyStatusLabel,
            ourReadyStatusStackView
        )
        
        contentView.addSubview(baseStackView)
        
        scrollView.addSubview(contentView)
        
        addSubviews(
            scrollView
        )
    }
    
    override func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        baseStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
