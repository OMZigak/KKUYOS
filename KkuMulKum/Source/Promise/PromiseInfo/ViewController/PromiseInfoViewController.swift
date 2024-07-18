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
    
    private let promiseInfoViewModel: PromiseInfoViewModel
    private let promiseInfoView: PromiseInfoView = PromiseInfoView()
    
    init(promiseInfoViewModel: PromiseInfoViewModel) {
        self.promiseInfoViewModel = promiseInfoViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = promiseInfoView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBinding()
        promiseInfoViewModel.fetchPromiseParticipantList()
    }
    
    override func setupDelegate() {
        promiseInfoView.participantCollectionView.delegate = self
        promiseInfoView.participantCollectionView.dataSource = self
    }
}


// MARK: - Extension

extension PromiseInfoViewController {
    func setupBinding() {
        promiseInfoViewModel.promiseInfo.bind(with: self) { owner, info in
            owner.promiseInfoView.timeContentLabel.setText(
                info?.time ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.promiseInfoView.readyLevelContentLabel.setText(
                info?.dressUpLevel ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.promiseInfoView.locationContentLabel.setText(
                info?.address ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.promiseInfoView.penaltyLevelContentLabel.setText(
                info?.penalty ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
        }
        
        promiseInfoViewModel.participantsInfo.bind(with: self) {
            owner,
            participantsInfo in
            DispatchQueue.main.async {
                owner.promiseInfoView.participantNumberLabel.setText(
                    "약속 참여 인원 \(participantsInfo?.count ?? 0)명",
                    style: .body01
                )
                owner.promiseInfoView.participantNumberLabel.setHighlightText(
                    "\(participantsInfo?.count ?? 0)명",
                    style: .body01,
                    color: .maincolor
                )
                
                owner.promiseInfoView.participantCollectionView.reloadData()
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
        return ((promiseInfoViewModel.participantsInfo.value?.count ?? 0) + 1)
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
        
        guard let info = promiseInfoViewModel.participantsInfo.value?[indexPath.row - 1] else {
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
