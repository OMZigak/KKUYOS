//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class PromiseViewController: BaseViewController {
    
    
    // MARK: Property
    
    private var promiseInfoView: PromiseInfoView = PromiseInfoView()
    private var readyStatusView: ReadyStatusView = ReadyStatusView()
    private var tardyView: TardyView = TardyView()
    private var arriveView: ArriveView = ArriveView()

    private var promiseViewList: [BaseView] = []
    
    private let viewModel: PromiseViewModel
    
    private var promiseSegmentedControl = PagePromiseSegmentedControl(
        items: ["약속 정보", "준비 현황", "지각 꾸물이"]
    )
    
    
    // MARK: Initializer

    init(promiseViewModel: PromiseViewModel) {
        self.viewModel = promiseViewModel
        
        self.viewModel.fetchPromiseInfo(promiseID: promiseViewModel.promiseID)
        
        promiseViewList = [
            promiseInfoView,
            readyStatusView,
            tardyView
        ]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarBackButton()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
        viewModel.fetchMyReadyStatus()
        viewModel.fetchPromiseParticipantList()
        viewModel.fetchTardyInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: viewModel.promiseInfo.value?.promiseName ?? "")
        
        view.addSubviews(
            promiseSegmentedControl,
            promiseViewList[0],
            promiseViewList[1],
            promiseViewList[2]
        )
        
        /// promiseInfoView만 보이도록 나머지 뷰 숨김 처리
        promiseViewList[0].isHidden = false
        promiseViewList[1].isHidden = true
        promiseViewList[2].isHidden = true
        
        promiseSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(-6)
            $0.height.equalTo(60)
        }
        
        promiseViewList.forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(promiseSegmentedControl.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    override func setupAction() {
        promiseSegmentedControl.addTarget(
            self,
            action: #selector(didSegmentedControlIndexUpdated),
            for: .valueChanged
        )
        
        readyStatusView.myReadyStatusProgressView.readyStartButton.addTarget(
            self,
            action: #selector(readyStartButtonDidTapped),
            for: .touchUpInside
        )
        
        readyStatusView.myReadyStatusProgressView.moveStartButton.addTarget(
            self,
            action: #selector(moveStartButtonDidTapped),
            for: .touchUpInside
        )
        
        readyStatusView.myReadyStatusProgressView.arrivalButton.addTarget(
            self,
            action: #selector(arrivalButtonDidTapped),
            for: .touchUpInside
        )
        
        readyStatusView.enterReadyButtonView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(enterReadyButtonDidTapped)
            )
        )
        
        tardyView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTapped),
            for: .touchUpInside
        )
        
        arriveView.finishMeetingButton.addTarget(
            self,
            action: #selector(finishMeetingButtonDidTapped),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        promiseInfoView.participantCollectionView.delegate = self
        promiseInfoView.participantCollectionView.dataSource = self
        readyStatusView.ourReadyStatusCollectionView.dataSource = self
    }
}


// MARK: - Extension

extension PromiseViewController {
    /// SegmentedControl 인덱스 업데이트 됐을 때 아래 라인 위치 업데이트하고 View 바꿔주는 함수
    @objc 
    private func didSegmentedControlIndexUpdated() {
        let condition = viewModel.currentPage.value <= promiseSegmentedControl.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = condition ? .forward : .reverse
        let (width, count, selectedIndex) = (
            promiseSegmentedControl.bounds.width,
            promiseSegmentedControl.numberOfSegments,
            promiseSegmentedControl.selectedSegmentIndex
        )
        
        promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset((width / CGFloat(count)) * CGFloat(selectedIndex))
        }
        
        viewModel.segmentIndexDidChanged(
            index: promiseSegmentedControl.selectedSegmentIndex
        )
        
        readyStatusView.updateCollectionViewHeight()
        
        /// promiseViewModel의 현재 인덱스 view만 두고 모두 숨김 처리
        for index in 0...2 {
            /// 약속 시간 지남 여부에 따라서 지각 꾸물이 뷰 교체
            promiseViewList[2] = viewModel.isPastDue.value ? arriveView : tardyView
            
            (index == viewModel.currentPage.value) ? (promiseViewList[index].isHidden = false) : (promiseViewList[index].isHidden = true)
        }
    }
    
    /// 약속 마치기 버튼 눌렀을 때 API 호출하고 현재 화면 닫는 함수
    @objc
    private func finishMeetingButtonDidTapped() {
        // TODO: 약속 마치기 눌렀을 때 모든 유저가 도착하지 않은 경우에 대한 분기 처리 필요
        viewModel.updatePromiseCompletion()
        
        navigationController?.popViewController(animated: true)
    }
    
    /// 준비 시작 버튼 눌렀을 때 실행되는 함수
    @objc
    private func readyStartButtonDidTapped() {
        viewModel.myReadyProgressStatus.value = .ready
        readyStatusView.myReadyStatusProgressView.readyStartButton.isEnabled.toggle()
    }
    
    /// 이동 시작 버튼 눌렀을 때 실행되는 함수
    @objc
    func moveStartButtonDidTapped() {
        viewModel.myReadyProgressStatus.value = .move
        readyStatusView.myReadyStatusProgressView.moveStartButton.isEnabled.toggle()
    }
    
    /// 도착 완료 버튼 눌렀을 때 실행되는 함수
    @objc
    func arrivalButtonDidTapped() {
        viewModel.myReadyProgressStatus.value = .done
        readyStatusView.myReadyStatusProgressView.arrivalButton.isEnabled.toggle()
    }
    
    /// 준비 정보 입력 버튼 눌렀을 때 실행되는 함수
    @objc
    func enterReadyButtonDidTapped() {
        guard !(viewModel.promiseInfo.value?.promiseName.count == 0) else { return }
        
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

private extension PromiseViewController {
    func setupBindings() {
        viewModel.promiseInfo.bind(with: self) { owner, info in
            owner.promiseInfoView.timeContentLabel.setText(
                info?.time ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.promiseInfoView.readyLevelContentLabel.setText(
                info?.dressUpLevel ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
            
            owner.promiseInfoView.locationContentLabel.setText(
                info?.address ?? "설정되지 않음",
                style: .body04,
                color: .gray7,
                isSingleLine: true
            )
            
            owner.promiseInfoView.penaltyLevelContentLabel.setText(
                info?.penalty ?? "설정되지 않음",
                style: .body04,
                color: .gray7
            )
        }
        
        viewModel.participantsInfo.bind(with: self) {
            owner,
            participantsInfo in
            DispatchQueue.main.async {
                owner.promiseInfoView.participantNumberLabel.setText(
                    "약속 참여 인원 \(participantsInfo?.count ?? 0)명",
                    style: .body01
                )
                owner.promiseInfoView.participantNumberLabel.setHighlightText(
                    "\(participantsInfo?.count ?? 0)명",
                    style: .body01,
                    color: .maincolor
                )
                
                owner.promiseInfoView.participantCollectionView.reloadData()
            }
        }
        
        viewModel.promiseInfo.bind { [weak self] model in
            guard let model else { return }
            DispatchQueue.main.async {
                self?.setupNavigationBarTitle(with: model.promiseName)
                self?.viewModel.promiseInfo.value = model
            }
        }
        
        viewModel.myReadyStatus.bind(with: self) {
            owner,
            model in
            DispatchQueue.main.async {
                guard let model else {
                    self.updateReadyInfoView(flag: false)
                    return
                }
            
                /// 준비 시간을 계산해 UI에 표시
                self.viewModel.calculateStartTime()
                self.viewModel.calculateTakenTime()
                
                /// myReadyStatus의 바인딩 부분에 조건을 통해 myReadyProgressStatus 값을 업데이트
                if model.preparationStartAt == nil {
                    self.viewModel.myReadyProgressStatus.value = .none
                }
                else if model.departureAt == nil {
                    self.viewModel.myReadyProgressStatus.value = .ready
                }
                else if model.arrivalAt == nil {
                    self.viewModel.myReadyProgressStatus.value = .move
                }
                else {
                    self.viewModel.myReadyProgressStatus.value = .done
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
            owner.readyStatusView.readyPlanInfoView.requestMoveTimeLabel.setText(
                "이동 소요 시간: \(moveTime)",
                style: .label02,
                color: .gray8
            )
        }
        
        viewModel.readyTime.bind(with: self) {
            owner,
            readyTime in
            owner.readyStatusView.readyPlanInfoView.requestReadyTimeLabel.setText(
                "준비 소요 시간: \(readyTime)",
                style: .label02,
                color: .gray8
            )
        }
        
        viewModel.readyStartTime.bind(with: self) {
            owner,
            readyStartTime in
            DispatchQueue.main.async {
                owner.readyStatusView.readyPlanInfoView.readyTimeLabel.setText(
                    "\(readyStartTime)에 준비하고,\n\(owner.viewModel.moveStartTime.value)에 이동을 시작해야 해요",
                    style: .body03
                )
                owner.readyStatusView.readyPlanInfoView.readyTimeLabel.setHighlightText(
                    readyStartTime,
                    self.viewModel.moveStartTime.value,
                    style: .body03,
                    color: .maincolor
                )
            }
        }
        
        viewModel.moveStartTime.bind(with: self) {
            owner,
            moveStartTime in
            DispatchQueue.main.async {
                owner.readyStatusView.readyPlanInfoView.readyTimeLabel.setText(
                    "\(owner.viewModel.readyStartTime.value)에 준비하고,\n\(moveStartTime)에 이동을 시작해야 해요",
                    style: .body03
                )
                owner.readyStatusView.readyPlanInfoView.readyTimeLabel.setHighlightText(
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
                owner.readyStatusView.ourReadyStatusCollectionView.reloadData()
                
                owner.readyStatusView.ourReadyStatusCollectionView.snp.updateConstraints {
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
        readyStatusView.enterReadyButtonView.isHidden = flag
        readyStatusView.readyPlanInfoView.isHidden = !flag
    }
    
    /// 준비 시작이나 이동 시작 시간이 늦었을 때 팝업 표시 여부 변경
    func updatePopUpImageView(isLate: Bool) {
        readyStatusView.popUpImageView.isHidden = !isLate
    }
    
    func updateReadyStartButton(status: ReadyProgressStatus) {
        switch status {
        case .none:
            DispatchQueue.main.async { [self] in
                self.readyStatusView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 시작",
                    .ready
                )
                self.readyStatusView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 시작",
                    .none
                )
                self.readyStatusView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .none
                )
                self.readyStatusView.myReadyStatusProgressView.statusProgressView.setProgress(
                    0,
                    animated: false
                )
            }
        case .ready:
            DispatchQueue.main.async { [self] in
                self.readyStatusView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 중",
                    .move
                )
                self.readyStatusView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 시작",
                    .ready
                )
                self.readyStatusView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .none
                )
                self.readyStatusView.myReadyStatusProgressView.statusProgressView.setProgress(
                    0.2,
                    animated: false
                )
                
                [
                    self.readyStatusView.myReadyStatusProgressView.moveStartTimeLabel,
                    self.readyStatusView.myReadyStatusProgressView.readyStartTitleLabel
                ].forEach { $0.isHidden = true }
                
                [
                    self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel,
                    self.readyStatusView.myReadyStatusProgressView.moveStartTitleLabel
                ].forEach { $0.isHidden = false }
                
                self.readyStatusView.myReadyStatusProgressView.readyStartCheckImageView.backgroundColor = .green2
                
                /// myReadyStatus의 preparationStartAt 값이 있으면 그 값으로 업데이트
                if let preparationStartAt = self.viewModel.myReadyStatus.value?.preparationStartAt {
                    self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        preparationStartAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                else {
                    self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        self.viewModel.updateReadyStatusTime(),
                        style: .caption02,
                        color: .gray8
                    )
                }
            }
            /// 준비 시작 네트워크 통신
            viewModel.updatePreparationStatus()
        case .move:
            DispatchQueue.main.async { [self] in
                self.readyStatusView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 중",
                    .done
                )
                self.readyStatusView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 중",
                    .move
                )
                self.readyStatusView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .ready
                )
                self.readyStatusView.myReadyStatusProgressView.statusProgressView.setProgress(
                    0.5,
                    animated: false
                )
                self.readyStatusView.myReadyStatusProgressView.arrivalTitleLabel.isHidden = false
                self.readyStatusView.myReadyStatusProgressView.moveStartTitleLabel.isHidden = true
                self.readyStatusView.myReadyStatusProgressView.readyStartTitleLabel.isHidden = true
                self.readyStatusView.myReadyStatusProgressView.arrivalTimeLabel.isHidden = true
                self.readyStatusView.myReadyStatusProgressView.moveStartTimeLabel.isHidden = false
                self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel.isHidden = false
                
                
                self.readyStatusView.myReadyStatusProgressView.readyStartCheckImageView.image = .iconCheck
                self.readyStatusView.myReadyStatusProgressView.moveStartCheckImageView.image = .iconCheck
                
                /// myReadyStatus의 arrivalAt 값이 있으면 그 값으로 업데이트
                if let preparationStartAt = self.viewModel.myReadyStatus.value?.preparationStartAt {
                    self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        preparationStartAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                if let departureAt = self.viewModel.myReadyStatus.value?.departureAt {
                    self.readyStatusView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                        departureAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                else {
                    self.readyStatusView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                        self.viewModel.updateReadyStatusTime(),
                        style: .caption02,
                        color: .gray8
                    )
                }
            }
            
            /// 이동 시작 네트워크 통신
            viewModel.updateDepartureStatus()
        case .done:
            DispatchQueue.main.async { [self] in
                self.readyStatusView.myReadyStatusProgressView.readyStartButton.setupButton(
                    "준비 중",
                    .done
                )
                self.readyStatusView.myReadyStatusProgressView.moveStartButton.setupButton(
                    "이동 중",
                    .done
                )
                self.readyStatusView.myReadyStatusProgressView.arrivalButton.setupButton(
                    "도착 완료",
                    .done
                )
                self.readyStatusView.myReadyStatusProgressView.statusProgressView.setProgress(
                    1,
                    animated: false
                )
                
                self.readyStatusView.myReadyStatusProgressView.arrivalTitleLabel.isHidden = true
                self.readyStatusView.myReadyStatusProgressView.moveStartTitleLabel.isHidden = true
                self.readyStatusView.myReadyStatusProgressView.readyStartTitleLabel.isHidden = true
                self.readyStatusView.myReadyStatusProgressView.arrivalTimeLabel.isHidden = false
                self.readyStatusView.myReadyStatusProgressView.moveStartTimeLabel.isHidden = false
                self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel.isHidden = false
                
                
                self.readyStatusView.myReadyStatusProgressView.readyStartCheckImageView.image = .iconCheck
                self.readyStatusView.myReadyStatusProgressView.moveStartCheckImageView.image = .iconCheck
                self.readyStatusView.myReadyStatusProgressView.arrivalCheckImageView.image = .iconCheck
                
                /// myReadyStatus의 arrivalAt 값이 있으면 그 값으로 업데이트
                if let preparationStartAt = self.viewModel.myReadyStatus.value?.preparationStartAt {
                    print("myReadyStatus의 preparationStartAt 값이 있어서 그 값으로 업데이트")
                    self.readyStatusView.myReadyStatusProgressView.readyStartTimeLabel.setText(
                        preparationStartAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                if let departureAt = self.viewModel.myReadyStatus.value?.departureAt {
                    print("myReadyStatus의 departureAt 값이 있으면 그 값으로 업데이트")
                    self.readyStatusView.myReadyStatusProgressView.moveStartTimeLabel.setText(
                        departureAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                if let arrivalAt = self.viewModel.myReadyStatus.value?.arrivalAt {
                    print("myReadyStatus의 arrivalAt 값이 있으면 그 값으로 업데이트")
                    self.readyStatusView.myReadyStatusProgressView.arrivalTimeLabel.setText(
                        arrivalAt,
                        style: .caption02,
                        color: .gray8
                    )
                }
                else {
                    self.readyStatusView.myReadyStatusProgressView.arrivalTimeLabel.setText(
                        viewModel.updateReadyStatusTime(),
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


// MARK: - UICollectionViewDataSource

extension PromiseViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == self.promiseInfoView.participantCollectionView {
            return (viewModel.participantsInfo.value?.count ?? 0) + 1
        }
        if collectionView == self.promiseInfoView.participantCollectionView {
            return viewModel.participantsInfo.value?.count ?? 0
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PromiseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == self.promiseInfoView.participantCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ParticipantCollectionViewCell
            else { return UICollectionViewCell() }
            
            if indexPath.row == 0 {
                cell.profileImageView.image = .imgEmptyCell
                cell.profileImageView.contentMode = .scaleAspectFill
                cell.userNameLabel.isHidden = true
                
                return cell
            }
            
            guard let info = viewModel.participantsInfo.value?[indexPath.row - 1] else {
                return cell
            }
            
            cell.userNameLabel.setText(info.name, style: .caption02, color: .gray6)
            
            guard let image = URL(string: info.profileImageURL ?? "") else {
                cell.profileImageView.image = .imgProfile
                
                return cell
            }
            
            cell.profileImageView.kf.setImage(with: image)
            
            return cell
        }
        
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
        
        if let imageURL = viewModel.participantsInfo.value?[indexPath.row].profileImageURL {
            cell.profileImageView.kf.setImage(with: URL(string: imageURL))
        } else {
            cell.profileImageView.image = .imgProfile
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
