//
//  MeetingInfoView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class MeetingInfoView: BaseView {
    
    
    // MARK: - Component
    
    let memberListView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 12
            $0.itemSize = .init(width: Screen.height(64), height: Screen.height(88))
        }
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            MeetingMemberCell.self,
            forCellWithReuseIdentifier: MeetingMemberCell.reuseIdentifier
        )
    }
    
    private let infoBanner = MeetingInfoBannerView()
    
    private let memberCountLabel = UILabel().then {
        $0.setText("모임 참여 인원 ?명", style: .body01, color: .gray8)
    }
    
    private let arrowButton = UIButton().then {
        let image = UIImage(resource: .iconRight).withTintColor(.gray4)
        $0.setImage(image, for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    private let addPromiseButton = UIButton().then {
        $0.setTitle("+ 약속추가", style: .body01, color: .white)
        $0.backgroundColor = .maincolor
        $0.layer.cornerRadius = Screen.height(52) / 2
        $0.clipsToBounds = true
    }
    
    override func setupView() {
        backgroundColor = .white
        
        addSubviews(
            infoBanner, memberCountLabel, arrowButton, memberListView, addPromiseButton
        )
        
        bringSubviewToFront(addPromiseButton)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        infoBanner.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        memberCountLabel.snp.makeConstraints {
            $0.top.equalTo(infoBanner.snp.bottom).offset(24)
            $0.leading.equalTo(infoBanner)
        }
        
        arrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-27)
            $0.centerY.equalTo(memberCountLabel)
        }
        
        memberListView.snp.makeConstraints {
            $0.top.equalTo(memberCountLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(Screen.height(88))
        }
        
        addPromiseButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).offset(-20)
            $0.trailing.equalTo(safeArea).offset(-14)
            $0.width.equalTo(Screen.width(136))
            $0.height.equalTo(Screen.height(52))
        }
    }
}

extension MeetingInfoView {
    func configureInfo(createdAt: String, metCount: Int) {
        infoBanner.configure(createdAt: createdAt, metCount: metCount)
    }
    
    func configureMemberCount(_ memberCount: Int) {
        memberCountLabel.do {
            $0.setText("모임 참여 인원 \(memberCount)명", style: .body01, color: .gray8)
            $0.setHighlightText("\(memberCount)명", style: .body01, color: .maincolor)
        }
    }
}
