//
//  TardyViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class TardyViewController: BaseViewController {
    private let rootView: TardyView = TardyView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setupAction() {
        rootView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTapped),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        rootView.tardyCollectionView.delegate = self
        rootView.tardyCollectionView.dataSource = self
    }
}


private extension TardyViewController {
    @objc
    func finishMeetingButtonDidTapped() {
        let arriveViewController = ArriveViewController()
        
        arriveViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(arriveViewController, animated: true)
    }
}


// MARK: UICollectionViewDelegate

extension TardyViewController: UICollectionViewDelegate {
    
}


// MARK: UICollectionViewDataSource

extension TardyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TardyCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TardyCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
