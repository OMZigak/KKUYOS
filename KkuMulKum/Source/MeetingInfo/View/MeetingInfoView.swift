//
//  MeetingInfoView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import UIKit

import RxCocoa
import RxSwift
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
        $0.setText("모임 참여 인원 0명", style: .body01, color: .gray8)
    }
    
    private let createPromiseButton = UIButton(backgroundColor: .maincolor).then {
        $0.setTitle("+   약속추가", style: .body01, color: .white)
        $0.layer.cornerRadius = Screen.height(52) / 2
        $0.clipsToBounds = true
    }
    
    private let grayBackgroundView = UIView(backgroundColor: .gray0).then {
        $0.roundCorners(
            cornerRadius: 18,
            maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        )
    }
    
    private let promiseDescriptionLabel = UILabel().then {
        $0.setText("남은 약속을 확인해보세요", style: .body01, color: .gray7)
    }
    
    private let segmentedControl = UnderlineSegmentedControl(items: ["내가 속한 약속", "모든 약속"]).then {
        $0.selectedSegmentIndex = 0
    }
    
    private let emptyDescriptionView = UIView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let emptyDescriptionLabel = UILabel().then {
        $0.setText("아직 약속이 없네요!\n약속을 추가해 보세요!", style: .body05, color: .gray3)
        $0.setHighlightText("약속을 추가", style: .body05, color: .maincolor)
        $0.textAlignment = .center
    }
    
    override func setupView() {
        backgroundColor = .white
        
        grayBackgroundView.addSubviews(
            promiseDescriptionLabel, segmentedControl, emptyDescriptionView, promiseListView
        )
        emptyDescriptionView.addSubviews(emptyDescriptionLabel)
        addSubviews(
            infoBanner, memberCountLabel, memberListView, createPromiseButton,
            grayBackgroundView
        )
        bringSubviewToFront(createPromiseButton)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        infoBanner.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        memberCountLabel.snp.makeConstraints {
            $0.top.equalTo(infoBanner.snp.bottom).offset(20)
            $0.leading.equalTo(infoBanner)
        }
        
        memberListView.snp.makeConstraints {
            $0.top.equalTo(memberCountLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(88))
        }
        
        grayBackgroundView.snp.makeConstraints {
            $0.top.equalTo(memberListView.snp.bottom).offset(35)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        promiseDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(promiseDescriptionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(Screen.height(26))
        }
        
        promiseListView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(188))
        }
        
        createPromiseButton.snp.makeConstraints {
            $0.top.equalTo(promiseListView.snp.bottom).offset(33)
            $0.trailing.equalTo(safeArea).offset(-16)
            $0.width.equalTo(Screen.width(136))
            $0.height.equalTo(Screen.height(52))
        }
        
        emptyDescriptionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(109)
        }
    }
}

extension MeetingInfoView {
    var createPromiseButtonDidTap: Observable<Void> { createPromiseButton.rx.tap.asObservable() }
    var selectedSegmentIndex: Observable<Int> { segmentedControl.rx.selectedSegmentIndex.asObservable() }
    
    func configureInfo(createdAt: String, metCount: Int) {
        infoBanner.configure(createdAt: createdAt, metCount: metCount)
    }
    
    func configureMemberCount(_ memberCount: Int) {
        memberCountLabel.do {
            $0.updateText("모임 참여 인원 \(memberCount)명")
            $0.setHighlightText("\(memberCount)명", style: .body01, color: .maincolor)
        }
    }
    
    func configureEmptyView(with flag: Bool) {
        emptyDescriptionView.isHidden = flag
    }
}
