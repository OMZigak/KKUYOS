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
            $0.estimatedItemSize = .init(width: Screen.width(68), height: Screen.height(88))
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            MeetingMemberCell.self,
            forCellWithReuseIdentifier: MeetingMemberCell.reuseIdentifier
        )
    }
    
    let promiseListView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 12
            $0.itemSize = .init(width: Screen.width(200), height: Screen.height(188))
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            MeetingPromiseCell.self,
            forCellWithReuseIdentifier: MeetingPromiseCell.reuseIdentifier
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
        $0.setTitle("+   약속추가", style: .body01, color: .white)
        $0.backgroundColor = .maincolor
        $0.layer.cornerRadius = Screen.height(52) / 2
        $0.clipsToBounds = true
    }
    
    // TODO: gray0으로 수정
    private let grayBackgroundView = UIView(backgroundColor: .gray).then {
        $0.roundCorners(
            cornerRadius: 18,
            maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        )
    }
    
    private let promiseDescriptionLabel = UILabel().then {
        $0.setText("남은 약속을 확인해보세요", style: .body01, color: .gray7)
    }
    
    override func setupView() {
        backgroundColor = .white
        
        grayBackgroundView.addSubviews(promiseDescriptionLabel, promiseListView)
        addSubviews(
            infoBanner, memberCountLabel, arrowButton, memberListView, addPromiseButton,
            grayBackgroundView
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
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(88))
        }
        
        grayBackgroundView.snp.makeConstraints {
            $0.top.equalTo(memberListView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeArea)
        }
        
        promiseDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        promiseListView.snp.makeConstraints {
            $0.top.equalTo(promiseDescriptionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(188))
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
