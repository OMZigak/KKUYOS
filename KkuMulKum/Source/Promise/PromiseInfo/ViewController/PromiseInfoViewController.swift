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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
    }
    
    @objc
    func editButtonDidTap() {
        
    }
}


// MARK: - UICollectionViewDataSource

extension PromiseInfoViewController: UICollectionViewDataSource {
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
            withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ParticipantCollectionViewCell else {
            return UICollectionViewCell()
        }
        
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

