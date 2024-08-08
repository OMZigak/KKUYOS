//
//  PromiseInfoViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class PromiseInfoViewController: BaseViewController {
    
    
    // MARK: Property
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBinding()
        viewModel.fetchPromiseParticipantList()
    }
    
    
    // MARK: - Setup
    
    override func setupDelegate() {
        rootView.participantCollectionView.delegate = self
        rootView.participantCollectionView.dataSource = self
    }
}


// MARK: - Extension

extension PromiseInfoViewController {
    func setupBinding() {
        viewModel.promiseInfo.bind(with: self) { owner, info in
            owner.rootView.timeContentLabel.setText(
                info?.time ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.rootView.readyLevelContentLabel.setText(
                info?.dressUpLevel ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.rootView.locationContentLabel.setText(
                info?.address ?? "설정되지 않음",
                style: .body04,
                color: .gray7,
                isSingleLine: true
            )
            
            owner.rootView.penaltyLevelContentLabel.setText(
                info?.penalty ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
        }
        
        viewModel.participantsInfo.bind(with: self) {
            owner,
            participantsInfo in
            DispatchQueue.main.async {
                owner.rootView.participantNumberLabel.setText(
                    "약속 참여 인원 \(participantsInfo?.count ?? 0)명",
                    style: .body01
                )
                owner.rootView.participantNumberLabel.setHighlightText(
                    "\(participantsInfo?.count ?? 0)명",
                    style: .body01,
                    color: .maincolor
                )
                
                owner.rootView.participantCollectionView.reloadData()
            }
        }
    }
}


// MARK: - UICollectionViewDataSource

extension PromiseInfoViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return ((viewModel.participantsInfo.value?.count ?? 0) + 1)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PromiseInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ParticipantCollectionViewCell 
        else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            cell.profileImageView.image = .imgEmptyCell
            cell.profileImageView.contentMode = .scaleAspectFill
            cell.userNameLabel.isHidden = true
            
            return cell
        }
        
        guard let info = viewModel.participantsInfo.value?[indexPath.row - 1] else {
            return cell
        }
        
        cell.userNameLabel.setText(info.name, style: .caption02, color: .gray6)
        
        guard let image = URL(string: info.profileImageURL ?? "") else {
            cell.profileImageView.image = .imgProfile
            
            return cell
        }
                
        cell.profileImageView.kf.setImage(with: image)
        
        return cell
    }
}
