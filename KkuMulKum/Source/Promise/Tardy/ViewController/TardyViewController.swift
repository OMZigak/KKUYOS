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
        
    }
}

// MARK: UICollectionViewDataSource

extension TardyViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 0
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
        
        return cell
    }
}
