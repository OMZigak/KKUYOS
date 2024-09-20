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
    let rootView: TardyView = TardyView()
    
    
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
    }
    
    
    // MARK: - Setup
    
    override func setupDelegate() {
        rootView.tardyCollectionView.dataSource = self
    }
}


// MARK: - Extension

private extension TardyViewController {
    func setupBinding() {
        viewModel.penalty.bindOnMain(with: self) { owner, penalty in
            owner.rootView.tardyPenaltyView.contentLabel.text = penalty
        }
        
        viewModel.isPastDue.bindOnMain(with: self) { owner, isPastDue in
            switch owner.viewModel.showTardyScreen() {
            case .tardyEmptyView:
                owner.rootView.do {
                    $0.finishMeetingButton.isEnabled = false
                    $0.tardyEmptyView.isHidden = false
                    $0.titleLabel.isHidden = false
                    $0.tardyPenaltyView.isHidden = false
                    $0.noTardyView.isHidden = true
                    $0.tardyCollectionView.isHidden = true
                }
            case .tardyListView:
                owner.rootView.do {
                    $0.finishMeetingButton.isEnabled = true
                    $0.titleLabel.isHidden = false
                    $0.tardyPenaltyView.isHidden = false
                    $0.tardyCollectionView.isHidden = false
                    $0.tardyEmptyView.isHidden = true
                    $0.noTardyView.isHidden = true
                    
                    $0.tardyCollectionView.reloadData()
                }
            case .noTardyView:
                owner.rootView.do {
                    $0.finishMeetingButton.isEnabled = true
                    $0.noTardyView.isHidden = false
                    $0.tardyEmptyView.isHidden = true
                    $0.titleLabel.isHidden = true
                    $0.tardyPenaltyView.isHidden = true
                    $0.tardyCollectionView.isHidden = true
                }
            }
        }
        
        viewModel.tardyList.bindOnMain(with: self) { owner, tardyList in
            switch owner.viewModel.showTardyScreen() {
            case .tardyEmptyView:
                owner.rootView.do {
                    $0.finishMeetingButton.isEnabled = false
                    $0.tardyEmptyView.isHidden = false
                    $0.titleLabel.isHidden = false
                    $0.tardyPenaltyView.isHidden = false
                    $0.noTardyView.isHidden = true
                    $0.tardyCollectionView.isHidden = true
                }
            case .tardyListView:
                owner.rootView.do {
                    $0.finishMeetingButton.isEnabled = true
                    $0.titleLabel.isHidden = false
                    $0.tardyPenaltyView.isHidden = false
                    $0.tardyCollectionView.isHidden = false
                    $0.tardyEmptyView.isHidden = true
                    $0.noTardyView.isHidden = true
                    
                    $0.tardyCollectionView.reloadData()
                }
            case .noTardyView:
                owner.rootView.do {
                    $0.finishMeetingButton.isEnabled = true
                    $0.noTardyView.isHidden = false
                    $0.tardyEmptyView.isHidden = true
                    $0.titleLabel.isHidden = true
                    $0.tardyPenaltyView.isHidden = true
                    $0.tardyCollectionView.isHidden = true
                }
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
        return viewModel.tardyList.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TardyCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TardyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let tardyName = viewModel.tardyList.value[indexPath.row].name else {
            return cell
        }
        
        cell.nameLabel.setText(tardyName, style: .body06, color: .gray6)
        cell.profileImageView.kf.setImage(
            with: URL(string: viewModel.tardyList.value[indexPath.row].profileImageURL ?? ""),
            placeholder: UIImage.imgProfile
        )
        
        return cell
    }
}
