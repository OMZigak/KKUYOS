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
    final let cellHeight: CGFloat = Screen.width(216)
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
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

        viewModel.requestLoginUser()
        viewModel.requestNearestPromise()
        viewModel.requestUpcomingPromise()
    }
    
    
    // MARK: - Function

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
        let promiseViewController = PromiseViewController(
            viewModel: PromiseViewModel(
                promiseID: viewModel.upcomingPromiseList.value?.data?.promises[indexPath.item].promiseID ?? 0, 
                service: PromiseService()
            )
        )
        
        tabBarController?.navigationController?.pushViewController(
            promiseViewController,
            animated: true
        )
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
            let formattedTime = viewModel.formattedTimes.value[indexPath.item]
            let formattedDay = viewModel.formattedDays.value[indexPath.item]
            let placeName = viewModel.placeNames.value[indexPath.item]
            
            cell.dataBind(
                data,
                formattedTime: formattedTime,
                formattedDay: formattedDay,
                placeName: placeName
            )
        }
        return cell
    }    
}


// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffsetY = rootView.scrollView.contentSize.height - rootView.scrollView.bounds.height
        
        rootView.backgroundColor = rootView.scrollView.contentOffset.y >= maxOffsetY ? .gray0 : .maincolor
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
    
    func setupBinding() {
        bindCurrentState()
        bindUserInfo()
        bindNearestPromise()
        bindUpcomingPromise()
    }
    
    func bindCurrentState() {
        viewModel.currentState.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .prepare:
                    self?.setPrepareUI()
                case .move:
                    self?.setMoveUI()
                case .arrive:
                    self?.setArriveUI()
                case .none:
                    self?.setNoneUI()
                }
            }
        }
    }
    
    func bindUserInfo() {
        viewModel.loginUser.bind { [weak self] _ in
            guard let self,
                  let responseBody = viewModel.loginUser.value,
                  let data = responseBody.data
            else {
                return
            }
            
            DispatchQueue.main.async {
                let characterImage = self.rootView.levelCharacterImage
                
                self.rootView.kkumulLabel.setText(
                    "\(data.name ?? "") 님,\n\(data.promiseCount)번의 약속에서\n\(data.tardyCount)번 꾸물거렸어요!",
                    style: .title02,
                    color: .white
                )
                self.rootView.kkumulLabel.setHighlightText(
                    "\(data.name ?? "") 님,",
                    style: .title00,
                    color: .white
                )
                self.rootView.kkumulLabel.setHighlightText(
                    for: ["\(data.promiseCount)번", "\(data.tardyCount)번"],
                    style: .title00,
                    color: .lightGreen
                )
                self.rootView.levelLabel.setText(
                    "Lv.\(data.level)  \(self.viewModel.levelName.value)",
                    style: .caption01,
                    color: .gray6
                )
                self.rootView.levelLabel.setHighlightText(
                    "Lv.\(data.level)",
                    style: .caption01,
                    color: .maincolor
                )
                self.rootView.levelCaptionLabel.setText(
                    self.viewModel.levelCaption.value,
                    style: .label01,
                    color: .white
                )
                switch data.level {
                case 1: characterImage.image = .imgLevel01
                case 2: characterImage.image = .imgLevel02
                case 3: characterImage.image = .imgLevel03
                case 4: characterImage.image = .imgLevel04
                default: break
                }
            }
        }
    }
    
    func bindNearestPromise() {
        viewModel.nearestPromise.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let data = self.viewModel.nearestPromise.value?.data
                
                if data == nil {
                    self.rootView.todayPromiseView.isHidden = true
                    self.rootView.todayButton.isHidden = true
                    self.rootView.todayEmptyView.isHidden = false
                } else {
                    self.rootView.todayPromiseView.isHidden = false
                    self.rootView.todayButton.isHidden = false
                    self.rootView.todayEmptyView.isHidden = true
                    self.rootView.todayPromiseView.meetingNameLabel.setText(
                        data?.meetingName ?? "",
                        style: .caption02,
                        color: .green3
                    )
                    self.rootView.todayPromiseView.nameLabel.setText(
                        data?.name ?? "",
                        style: .body03,
                        color: .gray8
                    )
                    self.rootView.todayPromiseView.placeNameLabel.setText(
                        self.viewModel.todayPlaceName.value,
                        style: .body06,
                        color: .gray7
                    )
                    self.rootView.todayPromiseView.timeLabel.setText(
                        self.viewModel.todayFormattedTime.value,
                        style: .body06,
                        color: .gray7
                    )
                }
            }
        }
    }
    
    func bindUpcomingPromise() {
        viewModel.upcomingPromiseList.bind { [weak self] _ in
            guard let self,
                  let responseBody = viewModel.upcomingPromiseList.value,
                  let data = responseBody.data
            else {
                return
            }
            
            DispatchQueue.main.async {
                if data.promises.isEmpty {
                    self.rootView.upcomingPromiseView.isHidden = true
                    self.rootView.upcomingEmptyView.isHidden = false
                } else {
                    self.rootView.upcomingPromiseView.isHidden = false
                    self.rootView.upcomingEmptyView.isHidden = true
                    self.rootView.upcomingPromiseView.reloadData()
                }
            }
        }
    }
    
   func getCurrentTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    
    func setDisableButton(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.gray3.cgColor
        sender.backgroundColor = .white
    }
    
    func setEnableButton(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .white
    }
    
    func setProgressButton(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .green2
    }
    
    func setCompleteButton(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.maincolor.cgColor
        sender.backgroundColor = .maincolor
    }
    
    func setNoneUI() {
        setEnableButton(rootView.todayPromiseView.prepareButton)
        setDisableButton(rootView.todayPromiseView.moveButton)
        setDisableButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.prepareButton.setTitle("준비 시작", style: .body05, color: .maincolor)
        rootView.todayPromiseView.moveButton.setTitle("이동 시작", style: .body05, color: .gray3)
        rootView.todayPromiseView.arriveButton.setTitle("도착 완료", style: .body05, color: .gray3)
        
        rootView.todayPromiseView.prepareButton.isEnabled = true
        rootView.todayPromiseView.moveButton.isEnabled = false
        rootView.todayPromiseView.arriveButton.isEnabled = false
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .gray2
        rootView.todayPromiseView.moveCircleView.backgroundColor = .gray2
        rootView.todayPromiseView.arriveCircleView.backgroundColor = .gray2
        
        rootView.todayPromiseView.prepareCheckView.isHidden = true
        rootView.todayPromiseView.moveCheckView.isHidden = true
        rootView.todayPromiseView.arriveCheckView.isHidden = true
        
        rootView.todayPromiseView.prepareLabel.isHidden = false
        rootView.todayPromiseView.moveLabel.isHidden = true
        rootView.todayPromiseView.arriveLabel.isHidden = true
        
        rootView.todayPromiseView.prepareLineView.isHidden = true
        rootView.todayPromiseView.moveLineView.isHidden = true
        rootView.todayPromiseView.arriveLineView.isHidden = true
        
        rootView.todayPromiseView.prepareTimeLabel.isHidden = true
        rootView.todayPromiseView.moveTimeLabel.isHidden = true
        rootView.todayPromiseView.arriveTimeLabel.isHidden = true
    }
    
    func setPrepareUI() {
        setProgressButton(rootView.todayPromiseView.prepareButton)
        setEnableButton(rootView.todayPromiseView.moveButton)
        setDisableButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.prepareButton.setTitle("준비 중", style: .body05, color: .maincolor)
        rootView.todayPromiseView.moveButton.setTitle("이동 시작", style: .body05, color: .maincolor)
        rootView.todayPromiseView.arriveButton.setTitle("도착 완료", style: .body05, color: .gray3)
        
        rootView.todayPromiseView.prepareButton.isEnabled = false
        rootView.todayPromiseView.moveButton.isEnabled = true
        rootView.todayPromiseView.arriveButton.isEnabled = false
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .green2
        rootView.todayPromiseView.moveCircleView.backgroundColor = .gray2
        rootView.todayPromiseView.arriveCircleView.backgroundColor = .gray2
        
        rootView.todayPromiseView.prepareCheckView.isHidden = true
        rootView.todayPromiseView.moveCheckView.isHidden = true
        rootView.todayPromiseView.arriveCheckView.isHidden = true
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = false
        rootView.todayPromiseView.arriveLabel.isHidden = true
        
        rootView.todayPromiseView.prepareLineView.isHidden = false
        rootView.todayPromiseView.moveLineView.isHidden = true
        rootView.todayPromiseView.arriveLineView.isHidden = true
        
        let currentTime = getCurrentTimeString()
        rootView.todayPromiseView.prepareTimeLabel.setText(
            self.viewModel.myReadyStatus.value?.data?.preparationStartAt ?? currentTime,
            style: .caption02,
            color: .gray8
        )
        
        rootView.todayPromiseView.prepareTimeLabel.isHidden = false
        rootView.todayPromiseView.moveTimeLabel.isHidden = true
        rootView.todayPromiseView.arriveTimeLabel.isHidden = true
    }
    
    func setMoveUI() {
        setCompleteButton(rootView.todayPromiseView.prepareButton)
        setProgressButton(rootView.todayPromiseView.moveButton)
        setEnableButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.prepareButton.setTitle("준비 중", style: .body05, color: .white)
        rootView.todayPromiseView.moveButton.setTitle("이동 중", style: .body05, color: .maincolor)
        rootView.todayPromiseView.arriveButton.setTitle("도착 완료", style: .body05, color: .maincolor)
        
        rootView.todayPromiseView.prepareButton.isEnabled = false
        rootView.todayPromiseView.moveButton.isEnabled = false
        rootView.todayPromiseView.arriveButton.isEnabled = true
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .maincolor
        rootView.todayPromiseView.moveCircleView.backgroundColor = .green2
        rootView.todayPromiseView.arriveCircleView.backgroundColor = .gray2
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = true
        rootView.todayPromiseView.arriveLabel.isHidden = false
        
        rootView.todayPromiseView.prepareCheckView.isHidden = false
        rootView.todayPromiseView.moveCheckView.isHidden = true
        rootView.todayPromiseView.arriveCheckView.isHidden = true
        
        rootView.todayPromiseView.prepareLineView.isHidden = false
        rootView.todayPromiseView.moveLineView.isHidden = false
        rootView.todayPromiseView.arriveLineView.isHidden = true
        
        let currentTime = getCurrentTimeString()
        rootView.todayPromiseView.prepareTimeLabel.setText(
            self.viewModel.myReadyStatus.value?.data?.preparationStartAt ?? currentTime,
            style: .caption02,
            color: .gray8
        )
        rootView.todayPromiseView.moveTimeLabel.setText(
            self.viewModel.myReadyStatus.value?.data?.departureAt ?? currentTime,
            style: .caption02,
            color: .gray8
        )
        
        rootView.todayPromiseView.prepareTimeLabel.isHidden = false
        rootView.todayPromiseView.moveTimeLabel.isHidden = false
        rootView.todayPromiseView.arriveTimeLabel.isHidden = true
    }
    
    func setArriveUI() {
        setCompleteButton(rootView.todayPromiseView.prepareButton)
        setCompleteButton(rootView.todayPromiseView.moveButton)
        setCompleteButton(rootView.todayPromiseView.arriveButton)
        
        rootView.todayPromiseView.prepareButton.setTitle("준비 중", style: .body05, color: .white)
        rootView.todayPromiseView.moveButton.setTitle("이동 중", style: .body05, color: .white)
        rootView.todayPromiseView.arriveButton.setTitle("도착 완료", style: .body05, color: .white)
        
        rootView.todayPromiseView.prepareButton.isEnabled = false
        rootView.todayPromiseView.moveButton.isEnabled = false
        rootView.todayPromiseView.arriveButton.isEnabled = false
        
        rootView.todayPromiseView.prepareCircleView.backgroundColor = .maincolor
        rootView.todayPromiseView.moveCircleView.backgroundColor = .maincolor
        rootView.todayPromiseView.arriveCircleView.backgroundColor = .maincolor
        
        rootView.todayPromiseView.prepareLabel.isHidden = true
        rootView.todayPromiseView.moveLabel.isHidden = true
        rootView.todayPromiseView.arriveLabel.isHidden = true
        
        rootView.todayPromiseView.prepareCheckView.isHidden = false
        rootView.todayPromiseView.moveCheckView.isHidden = false
        rootView.todayPromiseView.arriveCheckView.isHidden = false
        
        rootView.todayPromiseView.prepareLineView.isHidden = false
        rootView.todayPromiseView.moveLineView.isHidden = false
        rootView.todayPromiseView.arriveLineView.isHidden = false
        
        let currentTime = getCurrentTimeString()
        rootView.todayPromiseView.prepareTimeLabel.setText(
            self.viewModel.myReadyStatus.value?.data?.preparationStartAt ?? currentTime,
            style: .caption02,
            color: .gray8
        )
        rootView.todayPromiseView.moveTimeLabel.setText(
            self.viewModel.myReadyStatus.value?.data?.departureAt ?? currentTime,
            style: .caption02,
            color: .gray8
        )
        rootView.todayPromiseView.arriveTimeLabel.setText(
            self.viewModel.myReadyStatus.value?.data?.arrivalAt ?? currentTime,
            style: .caption02,
            color: .gray8
        )
        
        rootView.todayPromiseView.prepareTimeLabel.isHidden = false
        rootView.todayPromiseView.moveTimeLabel.isHidden = false
        rootView.todayPromiseView.arriveTimeLabel.isHidden = false
    }
    
    
    // MARK: - Action
    
    @objc
    func todayButtonDidTap(_ sender: UIButton) {
        let viewController = PromiseViewController(
            viewModel: PromiseViewModel(
                promiseID: viewModel.nearestPromise.value?.data?.promiseID ?? 0, 
                service: PromiseService()
            )
        )
        
        tabBarController?.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    @objc
    func prepareButtonDidTap(_ sender: UIButton) {
        viewModel.updatePrepareStatus()
        viewModel.currentState.value = .prepare
    }
    
    @objc
    func moveButtonDidTap(_ sender: UIButton) {
        viewModel.updateMoveStatus()
        viewModel.currentState.value = .move
    }
    
    @objc
    func arriveButtonDidTap(_ sender: UIButton) {
        viewModel.updateArriveStatus()
        viewModel.currentState.value = .arrive
    }
}
