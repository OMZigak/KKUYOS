//
//  TardyViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class TardyViewController: BaseViewController {
    
    
    // MARK: Property
    
    let viewModel: PromiseViewModel
    let tardyView: TardyView = TardyView()
    let arriveView: ArriveView = ArriveView()
    
    
    // MARK: Initialize
    
    init(viewModel: PromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    override func loadView() {
        view = viewModel.isPastDue.value ? arriveView : tardyView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    override func setupDelegate() {
        tardyView.tardyCollectionView.dataSource = self
    }
}


// MARK: - Extension

private extension TardyViewController {
    func setupBinding() {
        /// 시간이 지나고 지각자가 없을 때 arriveView로 띄워짐
        viewModel.isPastDue.bind(with: self) { owner, isPastDue in
            DispatchQueue.main.async {
                owner.tardyView.tardyCollectionView.isHidden = !isPastDue
                owner.tardyView.tardyEmptyView.isHidden = isPastDue
                owner.tardyView.finishMeetingButton.isEnabled = isPastDue
            }
        }
        
        viewModel.penalty.bind(with: self) {
            owner,
            penalty in
            DispatchQueue.main.async {
                owner.tardyView.tardyPenaltyView.contentLabel.setText(
                    penalty,
                    style: .body03,
                    color: .gray8
                )
            }
        }
        
        viewModel.hasTardy.bind(with: self) { owner, hasTardy in
            DispatchQueue.main.async {
                owner.view = hasTardy && owner.viewModel.isPastDue.value ? owner.arriveView : owner.tardyView
            }
        }
        
        viewModel.comers.bind(with: self) { owner, comers in
            DispatchQueue.main.async {
                owner.tardyView.tardyCollectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension TardyViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.comers.value?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TardyCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TardyCollectionViewCell else { return UICollectionViewCell() }
        
        guard let data = viewModel.comers.value?[indexPath.row] else { return cell }
        
        cell.nameLabel.setText(data.name ?? " " , style: .body06, color: .gray6)
        
        guard let imageURL = URL(string: data.profileImageURL ?? "") else {
            cell.profileImageView.image = .imgProfile
            return cell
        }
        cell.profileImageView.kf.setImage(with: imageURL)
        
        return cell
    }
}
