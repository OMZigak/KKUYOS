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
    let tardyView: TardyView = TardyView()
    let arriveView: ArriveView = ArriveView()
    
    
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
        let state = !tardyViewModel.hasTardy.value && tardyViewModel.isPastDue.value
        view = state ? tardyView : arriveView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 서버 통신하고 데이터 바인딩
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    override func setupDelegate() {
        tardyView.tardyCollectionView.delegate = self
        tardyView.tardyCollectionView.dataSource = self
    }
}


// MARK: - Extension

private extension TardyViewController {
    func setupBinding() {
        /// 시간이 지나고 지각자가 없을 때 arriveView로 띄워짐
        tardyViewModel.hasTardy.bind(with: self) { owner, flag in
            let state = !flag && owner.tardyViewModel.isPastDue.value
            owner.view = state ? owner.tardyView : owner.arriveView
        }
        
        /// isFinishButtonEnabled에 따라서 버튼 활성화 상태 변경
        tardyViewModel.isFinishButtonEnabled.bind(with: self) { owner, flag in
            self.tardyView.finishMeetingButton.isEnabled = flag
        }
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
        // TODO: 데이터 바인딩
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
