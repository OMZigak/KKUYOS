//
//  PromiseInfoViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PromiseInfoViewController: BaseViewController {
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 12
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }).then {
        $0.register(ParticipantCollectionViewCell.self, forCellWithReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(88)
        }
    }
    
    override func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension PromiseInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier, for: indexPath) as? ParticipantCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
