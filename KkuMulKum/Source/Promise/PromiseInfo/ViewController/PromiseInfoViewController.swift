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
    
    private let viewModel: PromiseViewModel
    private let rootView: PromiseInfoView = PromiseInfoView()
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBinding()
        viewModel.fetchPromiseParticipantList()
    }
    
    
    // MARK: - Setup
    
    override func setupDelegate() {
        rootView.participantCollectionView.delegate = self
        rootView.participantCollectionView.dataSource = self
    }
    
    override func setupAction() {
        rootView.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
}


// MARK: - Extension

private extension PromiseInfoViewController {
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
        viewModel.promiseInfo.bind(with: self) { owner, info in
            // TODO: 서버 API 반영되면 아래 주석 해제
            // owner.rootView.editButton.isHidden = info?.isParticipant!
            
            owner.rootView.timeContentLabel.setText(
                info?.time ?? "시간이 설정되지 않았어요!",
                style: .body04,
                color: .gray7
            )
            
            owner.rootView.readyLevelContentLabel.setText(
                info?.dressUpLevel ?? "꾸밈 난이도가 설정되지 않았어요!",
                style: .body04,
                color: .gray7
            )
            
            owner.rootView.locationContentLabel.setText(
                info?.address ?? "위치 정보가 설정되지 않았어요!",
                style: .body04,
                color: .gray7,
                isSingleLine: true
            )
            
            owner.rootView.penaltyLevelContentLabel.setText(
                info?.penalty ?? "벌칙이 설정되지 않았어요!",
                style: .body04,
                color: .gray7
            )
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
