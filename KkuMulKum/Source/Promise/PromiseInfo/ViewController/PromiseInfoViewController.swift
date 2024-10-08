//
//  PromiseInfoViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class PromiseInfoViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let viewModel: PromiseViewModel
    private let rootView: PromiseInfoView = PromiseInfoView()
    
    
    // MARK: - LifeCycle

    init(viewModel: PromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchTardyInfo()
        viewModel.fetchPromiseInfo()
        viewModel.fetchPromiseParticipantList()
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        view.backgroundColor = .gray0
    }
    
    override func setupDelegate() {
        rootView.participantCollectionView.delegate = self
        rootView.participantCollectionView.dataSource = self
    }
    
    override func setupAction() {
        rootView.editButton.addTarget(
            self,
            action: #selector(editButtonDidTap),
            for: .touchUpInside
        )
    }
}


// MARK: - Extension

extension PromiseInfoViewController {
    func setupBinding() {
        viewModel.promiseInfo.bindOnMain(with: self) { owner, info in
            guard let info else { return }
            let time = owner.viewModel.convertTime()
            
            owner.rootView.editButton.isHidden = owner.viewModel.isEditButtonHidden()
            owner.rootView.promiseNameLabel.setText(info.promiseName, style: .body01)
            owner.rootView.locationContentLabel.setText(info.placeName, style: .body04)
            owner.rootView.readyLevelContentLabel.setText(info.dressUpLevel, style: .body04)
            owner.rootView.penaltyLevelContentLabel.setText(info.penalty, style: .body04)
            owner.rootView.timeContentLabel.setText(time, style: .body04)
        }
        
        viewModel.participantList.bindOnMain(with: self) { owner, list in
            owner.rootView.participantNumberLabel.setText("\(list.count)명", style: .body05, color: .gray3)
            owner.rootView.participantCollectionView.reloadData()
        }
        
        viewModel.dDay.bindOnMain(with: self) { owner, dDay in
            guard let dDay else { return }
            
            switch dDay {
            case 1...:
                owner.rootView.dDayLabel.setText("D-\(dDay)", style: .body05, color: .gray5)
            case 0:
                owner.rootView.dDayLabel.setText("D-DAY", style: .body05, color: .mainorange)
            case ..<0:
                owner.rootView.do {
                    $0.dDayLabel.setText("D+\(-dDay)", style: .body05, color: .gray4)
                    $0.promiseImageView.image = .imgPromiseGray
                    $0.participantLabel.textColor = .gray4
                    $0.promiseNameLabel.textColor = .gray4
                    $0.locationInfoLabel.textColor = .gray4
                    $0.timeInfoLabel.textColor = .gray4
                    $0.readyLevelInfoLabel.textColor = .gray4
                    $0.penaltyLevelInfoLabel.textColor = .gray4
                }
            default:
                break
            }
        }
        
        viewModel.isPastDue.bindOnMain(with: self) { owner, _ in
            owner.rootView.editButton.isHidden = owner.viewModel.isEditButtonHidden()
        }
    }
    
    @objc
    func editButtonDidTap() {
        guard var dressUpLevel = viewModel.promiseInfo.value?.dressUpLevel else { return }
        
        let levels = ["LV1", "LV2", "LV3", "LV4", "FREE"]
        
        if dressUpLevel.contains("마음대로 입고 오기") {
            dressUpLevel = "FREE"
        } else {
            if let matched = levels.first(where: { level in
                dressUpLevel.replacingOccurrences(of: " ", with: "").contains(level)
            }) {
                dressUpLevel = matched
            }
        }
        
        let viewController = EditPromiseViewController(
            viewModel: EditPromiseViewModel(
                promiseID: viewModel.promiseID,
                promiseName: viewModel.promiseInfo.value?.promiseName,
                placeName: viewModel.promiseInfo.value?.placeName,
                xCoordinate: viewModel.promiseInfo.value?.x,
                yCoordinate: viewModel.promiseInfo.value?.y,
                address: viewModel.promiseInfo.value?.address,
                roadAddress: viewModel.promiseInfo.value?.roadAddress,
                time: viewModel.promiseInfo.value?.time,
                dressUpLevel: dressUpLevel,
                penalty: viewModel.promiseInfo.value?.penalty,
                service: PromiseService()
            )
        )
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension PromiseInfoViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.participantList.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ParticipantCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let info = viewModel.participantList.value[indexPath.row]
        
        cell.userNameLabel.setText(info.name, style: .caption02, color: .gray6)
        cell.profileImageView.kf.setImage(
            with: URL(string: info.profileImageURL ?? ""),
            placeholder: UIImage.imgProfile
        )
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PromiseInfoViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: Screen.width(68), height: Screen.height(88))
    }
}

