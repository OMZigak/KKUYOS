//
//  HomeViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/6/24.
//

import UIKit

import Then

class HomeViewController: BaseViewController {
    
    
    // MARK: - Property

    private let rootView = HomeView()
    
    private let viewModel: HomeViewModel
    
    final let cellWidth: CGFloat = Screen.width(200)
    final let cellHeight: CGFloat = Screen.height(216)
    final let contentInterSpacing: CGFloat = 12
    final let contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .maincolor
        register()
        
        updateUI()
        
        updateUserInfo()
        updateNearestPromise()
        updateUpcomingPromise()
        
        viewModel.requestLoginUser()
        viewModel.requestNearestPromise()
        viewModel.requestUpcomingPromise()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupAction() {
        rootView.todayButton.addTarget(
            self,
            action: #selector(todayButtonDidTap),
            for: .touchUpInside
        )
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
    
    override func setupDelegate() {
        rootView.upcomingPromiseView.delegate = self
        rootView.upcomingPromiseView.dataSource = self
        rootView.scrollView.delegate = self
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return contentInterSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return contentInset
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // TODO: promiseID를 모임 상세로 전달
        print(
            "promiseID: ",
            viewModel.upcomingPromiseList.value?.data?.promises[indexPath.item].promiseID ?? 0
        )
//        let viewController = PromiseInfoViewController(
//            viewModel: PromiseInfoViewModel(
//                promiseID: viewModel.upcomingPromiseList.value?.data?.promises[indexPath.item].promiseID ?? 0,
//                service: PromiseService()
//            )
//        )
        //tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.upcomingPromiseList.value?.data?.promises.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UpcomingPromiseCollectionViewCell.reuseIdentifier, 
            for: indexPath
        ) as? UpcomingPromiseCollectionViewCell else { return UICollectionViewCell() }
        if let data = viewModel.upcomingPromiseList.value?.data?.promises[indexPath.item] {
            cell.dataBind(data)
        }
        return cell
    }    
}


// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffsetY = rootView.scrollView.contentSize.height - rootView.scrollView.bounds.height
        if rootView.scrollView.contentOffset.y > maxOffsetY {
            rootView.scrollView.contentOffset.y = maxOffsetY
        }
    }
}


// MARK: - Function

private extension HomeViewController {
    func register() {
        rootView.upcomingPromiseView.register(
            UpcomingPromiseCollectionViewCell.self,
            forCellWithReuseIdentifier: UpcomingPromiseCollectionViewCell.reuseIdentifier
        )
    }
    
    func updateUI() {
        viewModel.currentState.bind { [weak self] state in
            switch state {
            case .prepare:
                self?.setPrepareUI()
            case .move:
                self?.setMoveUI()
            case .arrive:
                self?.setArriveUI()
            case .none:
                break
            }
        }
    }
    
    func updateUserInfo() {
        viewModel.loginUser.bind { [weak self] _ in
            DispatchQueue.main.async {
                let data = self?.viewModel.loginUser.value
                
                self?.rootView.kkumulLabel.setText(
                    "\(data?.data?.name ?? "") 님,\n\(data?.data?.promiseCount ?? 0)번의 약속에서\n\(data?.data?.tardyCount ?? 0)번 꾸물거렸어요!",
                    style: .title02,
                    color: .white
                )
                self?.rootView.kkumulLabel.setHighlightText(
                    "\(data?.data?.name ?? "") 님,",
                    style: .title00,
                    color: .white
                )
                self?.rootView.kkumulLabel.setHighlightText(
                    "\(data?.data?.promiseCount ?? 0)번",
                    "\(data?.data?.tardyCount ?? 0)번",
                    style: .title00,
                    color: .lightGreen
                )
                self?.rootView.levelLabel.setText(
                    "Lv.\(data?.data?.level ?? 0) \(self?.viewModel.levelName.value ?? "")",
                    style: .caption01,
                    color: .gray6
                )
                self?.rootView.levelLabel.setHighlightText(
                    "Lv.\(data?.data?.level ?? 0)",
                    style: .caption01,
                    color: .maincolor
                )
                self?.rootView.levelCaptionLabel.setText(
                    self?.viewModel.levelCaption.value ?? "",
                    style: .label01,
                    color: .white
                )
                switch data?.data?.level {
                case 1: self?.rootView.levelCharacterImage.image = .imgLevel01
                case 2: self?.rootView.levelCharacterImage.image = .imgLevel02
                case 3: self?.rootView.levelCharacterImage.image = .imgLevel03
                case 4: self?.rootView.levelCharacterImage.image = .imgLevel04
                default: break
                }
            }
        }
    }
    
    func updateNearestPromise() {
        viewModel.nearestPromise.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let data = self.viewModel.nearestPromise.value
                
                if data?.data == nil {
                    self.rootView.todayPromiseView.isHidden = true
                    self.rootView.todayEmptyView.isHidden = false
                } else {
                    self.rootView.todayPromiseView.meetingNameLabel.setText(
                        data?.data?.meetingName ?? "",
                        style: .caption02,
                        color: .green3
                    )
                    self.rootView.todayPromiseView.nameLabel.setText(
                        data?.data?.name ?? "",
                        style: .body03,
                        color: .gray8
                    )
                    self.rootView.todayPromiseView.placeNameLabel.setText(
                        data?.data?.placeName ?? "",
                        style: .body06,
                        color: .gray7
                    )
                    self.rootView.todayPromiseView.timeLabel.setText(
                        data?.data?.time ?? "",
                        style: .body06,
                        color: .gray7
                    )
                }
            }
        }
    }
    
    func updateUpcomingPromise() {
        viewModel.upcomingPromiseList.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let data = self.viewModel.nearestPromise.value
                
                if data?.data == nil {
                    self.rootView.upcomingPromiseView.isHidden = true
                    self.rootView.upcomingEmptyView.isHidden = false
                } else {
                    self.rootView.upcomingPromiseView.reloadData()
                }
            }
        }
    }
    
    func setDisableButton(_ sender: UIButton) {
        sender.setTitleColor(.gray3, for: .normal)
        sender.layer.borderColor = UIColor.gray3.cgColor
        sender.backgroundColor = .white
    }
    
    func setEnableButton(_ sender: UIButton) {
        sender.setTitleColor(.maincolor, for: .normal)
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .white
    }
    
    func setProgressButton(_ sender: UIButton) {
        sender.setTitleColor(.maincolor, for: .normal)
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .green2
    }
    
    func setCompleteButton(_ sender: UIButton) {
        sender.setTitleColor(.white, for: .normal)
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .maincolor
    }
    
    func setPrepareUI() {
        setProgressButton(rootView.todayPromiseView.prepareButton)
        rootView.todayPromiseView.moveButton.setTitle("준비 중", for: .normal)
        setEnableButton(rootView.todayPromiseView.moveButton)
        setDisableButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.prepareButton.isEnabled = false
        rootView.todayPromiseView.moveButton.isEnabled = true
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .green2
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = false
        
        rootView.todayPromiseView.prepareLineView.isHidden = false
    }
    
    func setMoveUI() {
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
    
    func setArriveUI() {
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
    
    
    // MARK: - Action
    
    @objc
    func todayButtonDidTap(_ sender: UIButton) {
        print(
            "promiseID: ",
            viewModel.nearestPromise.value?.data?.promiseID ?? 0
        )
        // TODO: promiseID를 모임 상세로 전달
//        let viewController = PromiseInfoViewController(
//            viewModel: PromiseInfoViewModel(
//                promiseID: viewModel.nearestPromise.value?.data?.promiseID ?? 0,
//                service: PromiseService()
//            )
//        )
        //tabBarController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func prepareButtonDidTap(_ sender: UIButton) {
        viewModel.updateState(newState: .prepare)
        rootView.todayPromiseView.prepareTimeLabel.setText(
            viewModel.homePrepareTime,
            style: .caption02,
            color: .gray8
        )
    }
    
    @objc
    func moveButtonDidTap(_ sender: UIButton) {
        viewModel.updateState(newState: .move)
        rootView.todayPromiseView.moveTimeLabel.setText(
            viewModel.homeMoveTime,
            style: .caption02,
            color: .gray8
        )
    }
    
    @objc
    func arriveButtonDidTap(_ sender: UIButton) {
        viewModel.updateState(newState: .arrive)
        rootView.todayPromiseView.arriveTimeLabel.setText(
            viewModel.homeArriveTime,
            style: .caption02,
            color: .gray8
        )
    }
}
