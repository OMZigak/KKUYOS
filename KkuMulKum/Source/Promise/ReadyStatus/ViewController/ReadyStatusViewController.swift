//
//  ReadyStatusViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class ReadyStatusViewController: BaseViewController {
    private let viewModel: PromiseViewModel

    private let rootView: ReadyStatusView = ReadyStatusView()
    
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
        
        viewModel.fetchMyReadyStatus()
        viewModel.fetchPromiseParticipantList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.updateCollectionViewHeight()
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
        viewModel.myReadyProgressStatus.value = .ready
        rootView.myReadyStatusProgressView.readyStartButton.isEnabled.toggle()
    }
    
    @objc
    func moveStartButtonDidTapped() {
        viewModel.myReadyProgressStatus.value = .move
        rootView.myReadyStatusProgressView.moveStartButton.isEnabled.toggle()
    }
    
    @objc
    func arrivalButtonDidTapped() {
        viewModel.myReadyProgressStatus.value = .done
        rootView.myReadyStatusProgressView.arrivalButton.isEnabled.toggle()
    }
    
    @objc
    func enterReadyButtonDidTapped() {
        guard let _ = viewModel.promiseInfo.value?.promiseName else { return }
        guard let readyStatusInfo = viewModel.myReadyStatus.value else { return }
        
        let setReadyInfoViewController = SetReadyInfoViewController(
            viewModel: SetReadyInfoViewModel(
                promiseID: viewModel.promiseID,
                promiseTime: readyStatusInfo.promiseTime,
                promiseName: viewModel.promiseInfo.value?.promiseName ?? "",
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
        return viewModel.participantsInfo.value?.count ?? 0
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
            viewModel.participantsInfo.value?[indexPath.row].name ?? "",
            style: .body03,
            color: .gray8
        )
        
        if let imageURL = URL(string: viewModel.participantsInfo.value?[indexPath.row].profileImageURL ?? "") {
            cell.profileImageView.kf.setImage(with: imageURL, placeholder: UIImage.imgProfile)
        }
        
        switch viewModel.participantsInfo.value?[indexPath.row].state {
        case "도착":
            cell.readyStatusButton.setupButton("도착", .done)
        case "이동중":
            cell.readyStatusButton.setupButton("이동중", .move)
        case "준비중":
            cell.readyStatusButton.setupButton("준비중", .ready)
        default:
            cell.readyStatusButton.setupButton("꾸물중", .none)
        }
        
        return cell
    }
}

private extension ReadyStatusViewController {
    func setupBinding() {
        viewModel.myReadyStatus.bind(with: self) {
            owner,
            model in
            DispatchQueue.main.async {
                guard let model else {
                    owner.updateReadyInfoView(flag: false)
                    return
                }
            
                /// 준비 시간을 계산해 UI에 표시
                owner.viewModel.calculateTakenTime()
                owner.viewModel.calculateStartTime()
                
                /// myReadyStatus의 바인딩 부분에 조건을 통해 myReadyProgressStatus 값을 업데이트
                if model.preparationStartAt == nil {
                    owner.viewModel.myReadyProgressStatus.value = .none
                }
                else if model.departureAt == nil {
                    owner.viewModel.myReadyProgressStatus.value = .ready
                }
                else if model.arrivalAt == nil {
                    owner.viewModel.myReadyProgressStatus.value = .move
                }
                else {
                    owner.viewModel.myReadyProgressStatus.value = .done
                }
                
                /// 준비하기 버튼과 준비 정보 화면 중 어떤 걸 표시할지 결정
                if model.preparationTime == nil {
                    owner.updateReadyInfoView(flag: false)
                    return
                }
                owner.updateReadyInfoView(flag: true)
            }
        }
        
        viewModel.moveTime.bind(with: self) {
            owner,
            moveTime in
            owner.rootView.readyPlanInfoView.requestMoveTimeLabel.setText(
                "이동 소요 시간: \(moveTime)",
                style: .label02,
                color: .gray8
            )
        }
        
        viewModel.readyTime.bind(with: self) {
            owner,
            readyTime in
            owner.rootView.readyPlanInfoView.requestReadyTimeLabel.setText(
                "준비 소요 시간: \(readyTime)",
                style: .label02,
                color: .gray8
            )
        }
        
        viewModel.readyStartTime.bind(with: self) {
            owner,
            readyStartTime in
            DispatchQueue.main.async {
                owner.rootView.readyPlanInfoView.readyTimeLabel.setText(
                    "\(readyStartTime)에 준비하고,\n\(owner.viewModel.moveStartTime.value)에 이동을 시작해야 해요",
                    style: .body03
                )
                owner.rootView.readyPlanInfoView.readyTimeLabel.setHighlightText(
                    readyStartTime,
                    owner.viewModel.moveStartTime.value,
                    style: .body03,
                    color: .maincolor
                )
            }
        }
        
        viewModel.moveStartTime.bind(with: self) {
            owner,
            moveStartTime in
            DispatchQueue.main.async {
                owner.rootView.readyPlanInfoView.readyTimeLabel.setText(
                    "\(owner.viewModel.readyStartTime.value)에 준비하고,\n\(moveStartTime)에 이동을 시작해야 해요",
                    style: .body03
                )
                owner.rootView.readyPlanInfoView.readyTimeLabel.setHighlightText(
                    owner.viewModel.readyStartTime.value,
                    moveStartTime,
                    style: .body03,
                    color: .maincolor
                )
            }
        }
        
        viewModel.myReadyProgressStatus.bind(with: self) { owner, status in
            DispatchQueue.main.async {
                owner.updateReadyStartButton(status: status)
            }
        }
        
        viewModel.participantsInfo.bind(with: self) { owner, participants in
            DispatchQueue.main.async {
                owner.rootView.ourReadyStatusCollectionView.reloadData()
                
                owner.rootView.ourReadyStatusCollectionView.snp.updateConstraints {
                    $0.height.equalTo(
                        CGFloat(participants?.count ?? 0) * Screen.height(80)
                    )
                }
            }
        }
        
        viewModel.isLate.bind(with: self) { owner, status in
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
    
    /// 준비 상태에 따라 버튼 상태 변경
    func updateReadyStartButton(status: ReadyProgressStatus) {
        switch status {
        case .none:
            DispatchQueue.main.async {
                self.rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 시작",
                    .ready
                )
                self.rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 시작",
                    .none
                )
                self.rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .none
                )
                self.rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                    0,
                    animated: false
                )
            }
        case .ready:
            DispatchQueue.main.async {
                self.rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 중",
                    .move
                )
                self.rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 시작",
                    .ready
                )
                self.rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .none
                )
                self.rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                    0.2,
                    animated: false
                )
                
                [
                    self.rootView.myReadyStatusProgressView.moveStartTimeLabel,
                    self.rootView.myReadyStatusProgressView.readyStartTitleLabel
                ].forEach { $0.isHidden = true }
                
                [
                    self.rootView.myReadyStatusProgressView.readyStartTimeLabel,
                    self.rootView.myReadyStatusProgressView.moveStartTitleLabel
                ].forEach { $0.isHidden = false }
                
                self.rootView.myReadyStatusProgressView.readyStartCheckImageView.backgroundColor = .green2
                
                /// myReadyStatus의 preparationStartAt 값이 있으면 그 값으로 업데이트
                if let preparationStartAt = self.viewModel.myReadyStatus.value?.preparationStartAt {
                    self.rootView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        preparationStartAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                else {
                    self.rootView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        self.viewModel.updateReadyStatusTime(),
                        style: .caption02,
                        color: .gray8
                    )
                }
            }
            
            /// 준비 시작 네트워크 통신
            viewModel.updatePreparationStatus()
        case .move:
            DispatchQueue.main.async {
                self.rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 중",
                    .done
                )
                self.rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 중",
                    .move
                )
                self.rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .ready
                )
                self.rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                    0.5,
                    animated: false
                )
                self.rootView.myReadyStatusProgressView.arrivalTitleLabel.isHidden = false
                self.rootView.myReadyStatusProgressView.moveStartTitleLabel.isHidden = true
                self.rootView.myReadyStatusProgressView.readyStartTitleLabel.isHidden = true
                self.rootView.myReadyStatusProgressView.arrivalTimeLabel.isHidden = true
                self.rootView.myReadyStatusProgressView.moveStartTimeLabel.isHidden = false
                self.rootView.myReadyStatusProgressView.readyStartTimeLabel.isHidden = false
                
                
                self.rootView.myReadyStatusProgressView.readyStartCheckImageView.image = .iconCheck
                self.rootView.myReadyStatusProgressView.moveStartCheckImageView.image = .iconCheck
                
                /// myReadyStatus의 arrivalAt 값이 있으면 그 값으로 업데이트
                if let preparationStartAt = self.viewModel.myReadyStatus.value?.preparationStartAt {
                    self.rootView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        preparationStartAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                if let departureAt = self.viewModel.myReadyStatus.value?.departureAt {
                    self.rootView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                        departureAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                else {
                    self.rootView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                        self.viewModel.updateReadyStatusTime(),
                        style: .caption02,
                        color: .gray8
                    )
                }
            }
            
            /// 이동 시작 네트워크 통신
            viewModel.updateDepartureStatus()
        case .done:
            DispatchQueue.main.async {
                self.rootView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 중",
                    .done
                )
                self.rootView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 중",
                    .done
                )
                self.rootView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .done
                )
                self.rootView.myReadyStatusProgressView.statusProgressView.setProgress(
                    1,
                    animated: false
                )
                
                [
                    self.rootView.myReadyStatusProgressView.arrivalTitleLabel,
                    self.rootView.myReadyStatusProgressView.moveStartTitleLabel,
                    self.rootView.myReadyStatusProgressView.readyStartTitleLabel
                ].forEach { $0.isHidden = true }
                
                [
                    self.rootView.myReadyStatusProgressView.arrivalTimeLabel,
                    self.rootView.myReadyStatusProgressView.moveStartTimeLabel,
                    self.rootView.myReadyStatusProgressView.readyStartTimeLabel
                ].forEach { $0.isHidden = false }
                
                [
                    self.rootView.myReadyStatusProgressView.readyStartCheckImageView,
                    self.rootView.myReadyStatusProgressView.moveStartCheckImageView,
                    self.rootView.myReadyStatusProgressView.arrivalCheckImageView
                ].forEach { $0.image = .iconCheck }
                
                /// myReadyStatus의 arrivalAt 값이 있으면 그 값으로 업데이트
                if let preparationStartAt = self.viewModel.myReadyStatus.value?.preparationStartAt {
                    self.rootView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        preparationStartAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                if let departureAt = self.viewModel.myReadyStatus.value?.departureAt {
                    self.rootView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                        departureAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                if let arrivalAt = self.viewModel.myReadyStatus.value?.arrivalAt {
                    self.rootView.myReadyStatusProgressView.arrivalTimeLabel.setText(
                        arrivalAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                else {
                    self.rootView.myReadyStatusProgressView.arrivalTimeLabel.setText(
                        self.viewModel.updateReadyStatusTime(),
                        style: .caption02,
                        color: .gray8
                    )
                }
            }
            
            /// 도착 완료 네트워크 통신
            viewModel.updateArrivalStatus()
        }
    }
}
