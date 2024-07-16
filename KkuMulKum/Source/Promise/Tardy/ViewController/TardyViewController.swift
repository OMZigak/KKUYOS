//
//  TardyViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class TardyViewController: BaseViewController {
    
    
    // MARK: Property

    private let tardyViewModel: TardyViewModel
    private let tardyView: TardyView = TardyView()
    private let arriveView: ArriveView = ArriveView()
    
    
    // MARK: Initialize

    init(tardyViewModel: TardyViewModel) {
        self.tardyViewModel = tardyViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup

    override func loadView() {
        view = tardyViewModel.hasTardy.value ? tardyView : arriveView
    }
    
    override func setupAction() {
        tardyView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTapped),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        tardyView.tardyCollectionView.delegate = self
        tardyView.tardyCollectionView.dataSource = self
    }
}


// MARK: - Extension

private extension TardyViewController {
    @objc
    func finishMeetingButtonDidTapped() {
        
    }
}


// MARK: UICollectionViewDelegate

extension TardyViewController: UICollectionViewDelegate {
    
}


// MARK: UICollectionViewDataSource

extension TardyViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TardyCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TardyCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
