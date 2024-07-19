//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class ReadyStatusViewController: BaseViewController {
    private let readyStatusViewModel: ReadyStatusViewModel

    private let rootView: ReadyStatusView = ReadyStatusView()
    
    init(readyStatusViewModel: ReadyStatusViewModel) {
        self.readyStatusViewModel = readyStatusViewModel
        
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
        
        readyStatusViewModel.fetchMyReadyStatus()
        readyStatusViewModel.fetchPromiseParticipantList()
    }
    
    override func setupDelegate() {
        rootView.ourReadyStatusCollectionView.dataSource = self
    }
    
    override func setupAction() {
        rootView.myReadyStatusProgressView.readyStartButton.addTarget(
            self,
            action: #selector(readyStartButtonDidTapped),
            for: .touchUpInside
        )
        rootView.myReadyStatusProgressView.moveStartButton.addTarget(
            self,
            action: #selector(moveStartButtonDidTapped),
            for: .touchUpInside
        )
        rootView.myReadyStatusProgressView.arrivalButton.addTarget(
            self,
            action: #selector(arrivalButtonDidTapped),
            for: .touchUpInside
        )
        rootView.enterReadyButtonView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(enterReadyButtonDidTapped)
            )
        )
    }
    
    @objc
    func readyStartButtonDidTapped() {
        // TODO: 늦었을 때 꾸물거릴 시간이 없어요 팝업 뜨도록 설정
        readyStatusViewModel.myReadyProgressStatus.value = .ready
        rootView.myReadyStatusProgressView.readyStartButton.isEnabled.toggle()
    }
    
    @objc
    func moveStartButtonDidTapped() {
        readyStatusViewModel.myReadyProgressStatus.value = .move
        rootView.myReadyStatusProgressView.moveStartButton.isEnabled.toggle()
    }
    
    @objc
    func arrivalButtonDidTapped() {
        readyStatusViewModel.myReadyProgressStatus.value = .done
        rootView.myReadyStatusProgressView.arrivalButton.isEnabled.toggle()
    }
    
    @objc
    func enterReadyButtonDidTapped() {
        guard !readyStatusViewModel.promiseName.value.isEmpty else { return }
        
        guard let readyStatusInfo = readyStatusViewModel.myReadyStatus.value else { return }
        
        let setReadyInfoViewController = SetReadyInfoViewController(
            viewModel: SetReadyInfoViewModel(
                promiseID: readyStatusViewModel.promiseID,
                promiseTime: readyStatusInfo.promiseTime,
                promiseName: readyStatusViewModel.promiseName.value,
                service: PromiseService()
            )
        )
        
        navigationController?.pushViewController(
            setReadyInfoViewController,
            animated: true
        )
    }
}


// MARK: - UICollectionViewDataSource

extension ReadyStatusViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return readyStatusViewModel.participantInfos.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OurReadyStatusCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? OurReadyStatusCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.nameLabel.setText(
            readyStatusViewModel.participantInfos.value[indexPath.row].name,
            style: .body03,
            color: .gray8
        )
        
        if let imageURL = readyStatusViewModel.participantInfos.value[indexPath.row].profileImageURL {
            cell.profileImageView.kf.setImage(with: URL(string: imageURL))
        } else {
            cell.profileImageView.image = .imgProfile
        }
        
        switch readyStatusViewModel.participantInfos.value[indexPath.row].state {
        case "도착":
            cell.readyStatusButton.setupButton("도착", .done)
        case "이동중":
            cell.readyStatusButton.setupButton("이동중", .move)
        case "준비중":
            cell.readyStatusButton.setupButton("준비중", .ready)
            cell.readyStatusButton.layer.borderWidth = 0
        default:
            cell.readyStatusButton.setupButton("꾸물중", .none)
        }
        
        return cell
    }
}

private extension ReadyStatusViewController {
    func setupBinding() {
        readyStatusViewModel.myReadyStatus.bind(with: self) { owner, model in
            DispatchQueue.main.async {
                guard let model else {
                    owner.updateReadyInfoView(flag: false)
                    return
                }
                
                if model.preparationTime == nil {
                    owner.updateReadyInfoView(flag: false)
                    return
                }
                // TODO: 시간 계산 로직 필요..
                owner.updateReadyInfoView(flag: true)
                owner.rootView.readyPlanInfoView.configure()
            }
        }
        
        readyStatusViewModel.myReadyProgressStatus.bind(with: self) { owner, status in
            DispatchQueue.main.async {
                owner.updateReadyStartButton(status: status)
            }
        }
        
        readyStatusViewModel.participantInfos.bind(with: self) { owner, participants in
            DispatchQueue.main.async {
                owner.rootView.ourReadyStatusCollectionView.reloadData()
                
                owner.rootView.ourReadyStatusCollectionView.snp.updateConstraints {
                    $0.height.equalTo(
                        CGFloat(participants.count) * Screen.height(72)
                    )
                }
            }
        }
        
        readyStatusViewModel.isLate.bind(with: self) { owner, status in
            DispatchQueue.main.async {
                self.updatePopUpImageView(isLate: !status)
            }
        }
    }
    
    /// flag에 따라 준비 정보 입력 버튼 표시 유무 변경
    func updateReadyInfoView(flag: Bool) {
        rootView.enterReadyButtonView.isHidden = flag
        rootView.readyPlanInfoView.isHidden = !flag
    }
    
    /// 준비 시작이나 이동 시작 시간이 늦었을 때 팝업 표시 여부 변경
    func updatePopUpImageView(isLate: Bool) {
        rootView.popUpImageView.isHidden = !isLate
    }
    
    func updateReadyStartButton(status: ReadyProgressStatus) {
        /// 버튼 누를 때 서버 통신하게 설정
        switch status {
        case .none:
            rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                "준비 시작",
                .ready
            )
            rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                "이동 시작",
                .none
            )
            rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                "도착 완료",
                .none
            )
            rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                0,
                animated: false
            )
        case .ready:
            rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                "준비 중",
                .move
            )
            rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                "이동 시작",
                .ready
            )
            rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                "도착 완료",
                .none
            )
            rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                0.2,
                animated: false
            )
            
            [
                rootView.myReadyStatusProgressView.moveStartTimeLabel,
                rootView.myReadyStatusProgressView.readyStartTitleLabel
            ].forEach { $0.isHidden = true }
            
            [
                rootView.myReadyStatusProgressView.readyStartTimeLabel,
                rootView.myReadyStatusProgressView.moveStartTitleLabel
            ].forEach { $0.isHidden = false }
            
            rootView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                readyStatusViewModel.updateReadyStatusTime(),
                style: .caption02,
                color: .gray8
            )
            
            rootView.myReadyStatusProgressView.readyStartCheckImageView.backgroundColor = .green2
        case .move:
            rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                "준비 중",
                .done
            )
            rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                "이동 중",
                .move
            )
            rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                "도착 완료",
                .ready
            )
            rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                0.5,
                animated: false
            )
            
            [
                rootView.myReadyStatusProgressView.moveStartTimeLabel,
                rootView.myReadyStatusProgressView.arrivalTitleLabel
            ].forEach { $0.isHidden = false }
            
            [
                rootView.myReadyStatusProgressView.arrivalTimeLabel,
                rootView.myReadyStatusProgressView.moveStartTitleLabel
            ].forEach { $0.isHidden = true }
            
            rootView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                readyStatusViewModel.updateReadyStatusTime(),
                style: .caption02,
                color: .gray8
            )
            
            rootView.myReadyStatusProgressView.readyStartCheckImageView.image = .iconCheck
            rootView.myReadyStatusProgressView.moveStartCheckImageView.backgroundColor = .green2
        case .done:
            rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                "준비 중",
                .done
            )
            rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                "이동 중",
                .done
            )
            rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                "도착 완료",
                .done
            )
            rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                1,
                animated: false
            )
            
            rootView.myReadyStatusProgressView.arrivalTitleLabel.isHidden = true
            rootView.myReadyStatusProgressView.arrivalTimeLabel.isHidden = false
            
            rootView.myReadyStatusProgressView.moveStartCheckImageView.image = .iconCheck
            rootView.myReadyStatusProgressView.arrivalCheckImageView.image = .iconCheck
            
            rootView.myReadyStatusProgressView.arrivalTimeLabel.setText(
                readyStatusViewModel.updateReadyStatusTime(),
                style: .caption02,
                color: .gray8
            )
        }
    }
}
