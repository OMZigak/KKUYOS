//
//  TardyViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class TardyViewController: BaseViewController {
    
    
    // MARK: Property
    
    let viewModel: PromiseViewModel
    let tardyView: TardyView = TardyView()
    let arriveView: ArriveView = ArriveView()
    
    
    // MARK: - LifeCycle

    init(viewModel: PromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchTardyInfo()
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        view.addSubviews(arriveView, tardyView)
        
        [arriveView, tardyView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    override func setupDelegate() {
        tardyView.tardyCollectionView.dataSource = self
    }
}


// MARK: - Extension

private extension TardyViewController {
    func setupBinding() {
        /// 시간이 지나고 지각자가 없을 때 arriveView로 띄워짐
        viewModel.isPastDue.bindOnMain(with: self) { owner, isPastDue in
            owner.tardyView.finishMeetingButton.isEnabled = (isPastDue && (owner.viewModel.promiseInfo.value?.isParticipant ?? false))
        }
        
        viewModel.penalty.bindOnMain(with: self) { owner, penalty in
            owner.tardyView.tardyPenaltyView.contentLabel.setText(
                penalty,
                style: .body03,
                color: .gray8
            )
        }
        
        viewModel.hasTardy.bindOnMain(with: self) { owner, hasTardy in
            let isPastDue = owner.viewModel.isPastDue.value
            let arriveHideFlag = !(isPastDue && !hasTardy)
            
            owner.arriveView.isHidden = arriveHideFlag
            owner.tardyView.isHidden = !arriveHideFlag
            owner.tardyView.tardyCollectionView.isHidden = !isPastDue
            owner.tardyView.tardyEmptyView.isHidden = isPastDue
        }
        
        viewModel.comers.bind(with: self) { owner, comers in
            DispatchQueue.main.async {
                owner.tardyView.tardyCollectionView.reloadData()
            }
        }
        
        viewModel.errorMessage.bindOnMain(with: self) { owner, error in
            let toast = Toast()
            toast.show(
                message: error,
                view: owner.view,
                position: .bottom,
                inset: 100
            )
        }
    }
}

// MARK: UICollectionViewDataSource

extension TardyViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.comers.value.count 
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TardyCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TardyCollectionViewCell else { return UICollectionViewCell() }
        
        cell.nameLabel.setText(
            viewModel.comers.value[indexPath.row].name ?? "",
            style: .body06,
            color: .gray6
        )
                
        cell.profileImageView.kf.setImage(
            with: URL(string: viewModel.comers.value[indexPath.row].profileImageURL ?? ""),
            placeholder: UIImage.imgProfile
        )
        
        return cell
    }
}
