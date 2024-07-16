//
//  PromiseInfoViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PromiseInfoViewController: BaseViewController {
    private let promiseInfoView: PromiseInfoView = PromiseInfoView()
    
    override func setupView() {
        view.addSubview(promiseInfoView)
        self.navigationController?.navigationBar.shadowImage = nil
        
        promiseInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupDelegate() {
        promiseInfoView.participantCollectionView.delegate = self
        promiseInfoView.participantCollectionView.dataSource = self
    }
}

extension PromiseInfoViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
}

extension PromiseInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ParticipantCollectionViewCell 
        else { return UICollectionViewCell() }
        
        return cell
    }
}
