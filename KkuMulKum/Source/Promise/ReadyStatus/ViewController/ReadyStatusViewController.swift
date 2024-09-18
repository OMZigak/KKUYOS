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
        
        view.backgroundColor = .gray0
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchTardyInfo()
        viewModel.fetchPromiseInfo()
        viewModel.fetchMyReadyStatus()
        viewModel.fetchPromiseParticipantList()
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
            action: #selector(readyStartButtonDidTap),
            for: .touchUpInside
        )
        rootView.myReadyStatusProgressView.moveStartButton.addTarget(
            self,
            action: #selector(moveStartButtonDidTap),
            for: .touchUpInside
        )
        rootView.myReadyStatusProgressView.arrivalButton.addTarget(
            self,
            action: #selector(arrivalButtonDidTap),
            for: .touchUpInside
        )
        rootView.readyPlanInfoView.editButton.addTarget(
            self,
            action: #selector(editReadyButtonDidTap),
            for: .touchUpInside
        )
        rootView.enterReadyButtonView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(enterReadyButtonDidTap)
            )
        )
    }
}


// MARK: - Extension

extension ReadyStatusViewController {
    func setupBinding() {
        viewModel.participantList.bindOnMain(with: self) { owner, _ in
            owner.rootView.ourReadyStatusCollectionView.reloadData()
        }
        
        viewModel.isPastDue.bindOnMain(with: self) { owner, isPastDue in
            guard let isPastDue else { return }
            
            owner.rootView.readyPlanInfoView.editButton.isHidden = isPastDue
        }
        
        viewModel.promiseInfo.bindOnMain(with: self) { owner, info in
            guard let promiseInfo = info else { return }
            
            owner.rootView.do {
                $0.enterReadyButtonView.isHidden = owner.viewModel.isReadyInfoEntered()
                $0.readyPlanInfoView.isHidden = !$0.enterReadyButtonView.isHidden
                $0.enterReadyButtonView.isUserInteractionEnabled = promiseInfo.isParticipant
            }
        }
        
        viewModel.myReadyInfo.bindOnMain(with: self) { owner, status in
            owner.rootView.do {
                $0.enterReadyButtonView.isHidden = owner.viewModel.isReadyInfoEntered()
                $0.readyPlanInfoView.isHidden = !$0.enterReadyButtonView.isHidden
            }
        }
        
        viewModel.requestReadyTime.bindOnMain(with: self) { owner, time in
            owner.rootView.do {
                $0.readyPlanInfoView.readyTimeLabel.setText("\(time[0])에 준비하고,\n\(time[1])에 이동을 시작해야 해요", style: .body03)
                $0.readyPlanInfoView.readyTimeLabel.setHighlightText("\(time[0])","\(time[1])", style: .body03, color: .maincolor)
                $0.readyPlanInfoView.requestReadyTimeLabel.setText("준비 소요 시간: \(time[2])", style: .label02, color: .gray8)
                $0.readyPlanInfoView.requestMoveTimeLabel.setText("이동 소요 시간: \(time[3])", style: .label02, color: .gray8)
            }
        }
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
        guard let promiseName = viewModel.promiseInfo.value?.promiseName,
              let promiseTime = viewModel.myReadyInfo.value?.promiseTime,
              let preparationTime = viewModel.myReadyInfo.value?.preparationTime,
              let travelTime = viewModel.myReadyInfo.value?.travelTime else {
            return
        }
        
        let viewModel = SetReadyInfoViewModel(
            promiseID: viewModel.promiseID,
            promiseTime: promiseTime,
            promiseName: promiseName,
            service: PromiseService()
        )
        
        viewModel.storedReadyHour = preparationTime / 60
        viewModel.storedReadyMinute = preparationTime % 60
        viewModel.storedMoveHour = travelTime / 60
        viewModel.storedMoveMinute = travelTime % 60
        
        let viewController = SetReadyInfoViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func enterReadyButtonDidTap() {
        guard let promiseName = viewModel.promiseInfo.value?.promiseName,
              let readyInfo = viewModel.myReadyInfo.value else {
            return
        }
        
        let viewController = SetReadyInfoViewController(
            viewModel: SetReadyInfoViewModel(
                promiseID: viewModel.promiseID,
                promiseTime: readyInfo.promiseTime,
                promiseName: promiseName,
                service: PromiseService()
            )
        )
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension ReadyStatusViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.participantList.value.count
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
        
        let info = viewModel.participantList.value[indexPath.row]
        
        switch info.state {
        case "꾸물중":
            cell.readyStatusButton.setupButton("꾸물중", .none)
        case "준비중":
            cell.readyStatusButton.setupButton("준비중", .ready)
        case "이동중":
            cell.readyStatusButton.setupButton("이동중", .move)
        case "도착":
            cell.readyStatusButton.setupButton("도착", .done)
        default:
            break
        }
        
        cell.nameLabel.text = info.name
        cell.profileImageView.kf.setImage(
            with: URL(string: info.profileImageURL ?? ""),
            placeholder: UIImage.imgProfile
        )
        
        return cell
    }
}
