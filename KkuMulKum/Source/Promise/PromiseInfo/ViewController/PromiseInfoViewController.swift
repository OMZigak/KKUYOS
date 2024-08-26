//
//  PromiseInfoViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import Kingfisher

class PromiseInfoViewController: BaseViewController {
    
    
    // MARK: Property
    
    let rootView: PromiseInfoView = PromiseInfoView()
    let viewModel: PromiseViewModel
    
    
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
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchPromiseParticipantList()
        viewModel.fetchPromiseInfo(promiseID: viewModel.promiseID)
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        view.backgroundColor = .gray0
    }
    
    override func setupDelegate() {
        rootView.participantCollectionView.delegate = self
        rootView.participantCollectionView.dataSource = self
    }
    
    override func setupAction() {
        rootView.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
}


// MARK: - Extension

extension PromiseInfoViewController {
    @objc
    func editButtonDidTap() {
        let viewController = EditPromiseViewController(
            viewModel: EditPromiseViewModel(
                promiseID: viewModel.promiseID,
                promiseName: viewModel.promiseInfo.value?.promiseName,
                placeName: viewModel.promiseInfo.value?.placeName,
                time: viewModel.promiseInfo.value?.time,
                dressUpLevel: viewModel.promiseInfo.value?.dressUpLevel,
                penalty: viewModel.promiseInfo.value?.penalty,
                service: PromiseService()
            )
        )
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupBinding() {
        /// promiseInfo 할당 자체가 비동기
        viewModel.promiseInfo.bind(with: self) { owner, info in
            DispatchQueue.main.async {
                owner.rootView.editButton.isHidden = !(info?.isParticipant ?? false)
                
                
                
                print(">>>>> \(info) : \(#function)")
            }
        }
        
        viewModel.participantsInfo.bind(with: self) { owner, participantsInfo in
            DispatchQueue.main.async {
                owner.rootView.participantNumberLabel.setText(
                    "약속 참여 인원 \(participantsInfo?.count ?? 0)명",
                    style: .body05,
                    color: .maincolor
                )
                
                owner.rootView.participantNumberLabel.setHighlightText(
                    "\(participantsInfo?.count ?? 0)명",
                    style: .body05,
                    color: .gray3
                )
                
                owner.rootView.participantCollectionView.reloadData()
            }
        }
    }
    
    func setupContent() {
        print(">>>>> \(self.viewModel.promiseInfo.value) : \(#function)")
        
        /// 데이터가 있는데 if let이 첫번째 디버깅(promiseVC)에서는 당연히 안받아와지고
        /// 두번째 디버깅(fetchPromiseIInfo)에서는 받아와짐
        /// 근데 두번째 디버깅 밑 setUpContent는 UI가 안바뀜
        /// PromiseVC 외부에서 정보를 받아올 수 없어(사유: 통신 함수 선언은 뷰모델 내부에 잇음) 조졋다.
        if let name = self.viewModel.promiseInfo.value?.promiseName {
            self.rootView.promiseNameLabel.setText(name, style: .body04)
        } else {
            print("넌조졋다")
        }
        
        self.rootView.locationContentLabel.setText(
            self.viewModel.promiseInfo.value?.placeName ?? "약속 장소 미설정",
            style: .body04
        )
        self.rootView.readyLevelContentLabel.setText(
            self.viewModel.promiseInfo.value?.dressUpLevel ?? "꾸레벨 미설정",
            style: .body04
        )
        self.rootView.penaltyLevelContentLabel.setText(
            self.viewModel.promiseInfo.value?.penalty ?? "벌칙 미설정",
            style: .body04
        )
    }
    
    func setUpTimeContent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = dateFormatter.date(from: viewModel.promiseInfo.value?.time ?? "") else {
            return
        }
        
        dateFormatter.dateFormat = "M월 d일 a h:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let time = dateFormatter.string(from: date)
        
        let currentDate = Calendar.current
        
        let components = currentDate.dateComponents([.day], from: Date(), to: date)
        guard let remainDay = components.day else {
            return
        }
        
        rootView.timeContentLabel.setText(time, style: .body04)
        
        if remainDay == 0 {
            rootView.dDayLabel.setText("D-DAY" ,style: .body05, color: .mainorange)
            rootView.promiseImageView.image = .imgPromise
            rootView.promiseNameLabel.textColor = .gray7
        }
        else if remainDay < 0 {
            rootView.dDayLabel.setText("D+\(remainDay)" ,style: .body05, color: .gray4)
            rootView.promiseImageView.image = .imgPromiseGray
            rootView.promiseNameLabel.textColor = .gray4
        }
        else {
            rootView.dDayLabel.setText("D-\(remainDay)" ,style: .body05, color: .gray5)
            rootView.promiseImageView.image = .imgPromise
            rootView.promiseNameLabel.textColor = .gray7
        }
    }
}


// MARK: - UICollectionViewDataSource

extension PromiseInfoViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return (viewModel.participantsInfo.value?.count ?? 0)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PromiseInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParticipantCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ParticipantCollectionViewCell 
        else { return UICollectionViewCell() }
        
        guard let info = viewModel.participantsInfo.value?[indexPath.row] else {
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
}
