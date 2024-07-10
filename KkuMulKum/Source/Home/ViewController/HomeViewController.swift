//
//  HomeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

class HomeViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = HomeView()
    
    final let cellWidth: CGFloat = 200
    final let cellHeight: CGFloat = 216
    final let contentInterSpacing: CGFloat = 12
    final let contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    final let cellNumber = 4
    
    private var contentData = UpcomingPromiseModel.dummy() {
        didSet {
            self.rootView.upcomingPromiseView.reloadData()
        }
    }


    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.isNavigationBarHidden = true
    }

    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        register()
        setupDelegate()
    }
    
    private func register() {
        rootView.upcomingPromiseView.register(UpcomingPromiseCollectionViewCell.self,
            forCellWithReuseIdentifier: UpcomingPromiseCollectionViewCell.reuseIdentifier
        )
    }
    
    override func setupDelegate() {
        rootView.upcomingPromiseView.delegate = self
        rootView.upcomingPromiseView.dataSource = self
    }
    
    override func setupAction() {
        
    }
}


// MARK: - UICollectionView Setting

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return contentInterSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return contentInset
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UpcomingPromiseCollectionViewCell.reuseIdentifier, for: indexPath
        ) as? UpcomingPromiseCollectionViewCell else { return UICollectionViewCell() }
        cell.dataBind(contentData[indexPath.item], itemRow: indexPath.item)
        return cell
    }    
}
