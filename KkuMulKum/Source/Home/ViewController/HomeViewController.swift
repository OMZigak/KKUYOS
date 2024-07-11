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
        setupAction()
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
    
    
    // MARK: - Function
    
    override func setupAction() {
        rootView.todayPromiseView.prepareButton.addTarget(
            self,
            action: #selector(prepareButtonDidTap),
            for: .touchUpInside
        )
        rootView.todayPromiseView.moveButton.addTarget(
            self,
            action: #selector(moveButtonDidTap),
            for: .touchUpInside
        )
        rootView.todayPromiseView.arriveButton.addTarget(
            self,
            action: #selector(arriveButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func setDisableButton(_ sender: UIButton) {
        sender.setTitleColor(.gray3, for: .normal)
        sender.layer.borderColor = UIColor.gray3.cgColor
        sender.backgroundColor = .white
    }
    
    private func setEnableButton(_ sender: UIButton) {
        sender.setTitleColor(.maincolor, for: .normal)
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .white
    }
    
    private func setProgressButton(_ sender: UIButton) {
        sender.setTitleColor(.maincolor, for: .normal)
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .green2
    }
    
    private func setCompleteButton(_ sender: UIButton) {
        sender.setTitleColor(.white, for: .normal)
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .maincolor
    }
    
    
    // MARK: - Action
    
    @objc
    private func prepareButtonDidTap(_ sender: UIButton) {
        setProgressButton(rootView.todayPromiseView.prepareButton)
        setEnableButton(rootView.todayPromiseView.moveButton)
        setDisableButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.prepareButton.isEnabled = false
        rootView.todayPromiseView.moveButton.isEnabled = true
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .green2
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = false
    
        rootView.todayPromiseView.prepareLineView.isHidden = false
    }

    @objc
    private func moveButtonDidTap(_ sender: UIButton) {
        setCompleteButton(rootView.todayPromiseView.prepareButton)
        rootView.todayPromiseView.moveButton.setTitle("이동 중", for: .normal)
        setProgressButton(rootView.todayPromiseView.moveButton)
        setEnableButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.moveButton.isEnabled = false
        rootView.todayPromiseView.arriveButton.isEnabled = true
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .maincolor
        rootView.todayPromiseView.moveCircleView.backgroundColor = .green2
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = true
        rootView.todayPromiseView.arriveLabel.isHidden = false
        
        rootView.todayPromiseView.prepareCheckView.isHidden = false
        rootView.todayPromiseView.moveLineView.isHidden = false
    }
    
    @objc
    private func arriveButtonDidTap(_ sender: UIButton) {
        setCompleteButton(rootView.todayPromiseView.prepareButton)
        setCompleteButton(rootView.todayPromiseView.moveButton)
        setCompleteButton(rootView.todayPromiseView.arriveButton)

        rootView.todayPromiseView.moveButton.isEnabled = false
        rootView.todayPromiseView.arriveButton.isEnabled = false
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .maincolor
        rootView.todayPromiseView.moveCircleView.backgroundColor = .maincolor
        rootView.todayPromiseView.arriveCircleView.backgroundColor = .maincolor
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = true
        rootView.todayPromiseView.arriveLabel.isHidden = true
        
        rootView.todayPromiseView.moveCheckView.isHidden = false
        rootView.todayPromiseView.arriveCheckView.isHidden = false
        rootView.todayPromiseView.arriveLineView.isHidden = false
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
