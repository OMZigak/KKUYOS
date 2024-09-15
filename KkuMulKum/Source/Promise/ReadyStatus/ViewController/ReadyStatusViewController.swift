//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class ReadyStatusViewController: BaseViewController {
    
    
    // MARK: Property
    
    private let viewModel: PromiseViewModel
    private let rootView: ReadyStatusView = ReadyStatusView()
    
    
    // MARK: - LifeCycle
    
    init(
        viewModel: PromiseViewModel
    ) {
        self.viewModel = viewModel
        
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray0
        
        setupBinding()
    }
    
    override func viewWillAppear(
        _ animated: Bool
    ) {
        super.viewWillAppear(
            animated
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.updateCollectionViewHeight()
    }
    
    
    // MARK: - Setup
    
    override func setupDelegate() {
        rootView.ourReadyStatusCollectionView.dataSource = self
    }
    
    override func setupAction() {
        rootView.myReadyStatusProgressView.readyStartButton.addTarget(
            self,
            action: #selector(
                readyStartButtonDidTap
            ),
            for: .touchUpInside
        )
        rootView.myReadyStatusProgressView.moveStartButton.addTarget(
            self,
            action: #selector(
                moveStartButtonDidTap
            ),
            for: .touchUpInside
        )
        rootView.myReadyStatusProgressView.arrivalButton.addTarget(
            self,
            action: #selector(
                arrivalButtonDidTap
            ),
            for: .touchUpInside
        )
        rootView.readyPlanInfoView.editButton.addTarget(
            self,
            action: #selector(
                editReadyButtonDidTap
            ),
            for: .touchUpInside
        )
        rootView.enterReadyButtonView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(
                    enterReadyButtonDidTap
                )
            )
        )
    }
}


// MARK: - Extension

extension ReadyStatusViewController {
    func setupBinding() {
        
    }
    
    @objc
    func readyStartButtonDidTap() {
        
    }
    
    @objc
    func moveStartButtonDidTap() {
        
    }
    
    @objc
    func arrivalButtonDidTap() {
        
    }
    
    @objc
    func editReadyButtonDidTap() {
        
    }
    
    @objc
    func enterReadyButtonDidTap() {
        
    }
}


// MARK: - UICollectionViewDataSource

extension ReadyStatusViewController: UICollectionViewDataSource {
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
            withReuseIdentifier: OurReadyStatusCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? OurReadyStatusCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
