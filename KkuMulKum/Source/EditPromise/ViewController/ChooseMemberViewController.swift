//
//  ChooseMemberViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import UIKit

class ChooseMemberViewController: BaseViewController {
    let viewModel: EditPromiseViewModel
    
    private let rootView: SelectMemberView = SelectMemberView()
    
    
    // MARK: - LifeCycle
    
    init(viewModel: EditPromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "약속 수정하기", isBorderHidden: true)
        
        setupBinding()
        
        viewModel.fetchPromiseAvailableMember() {
            self.setupSelectInitialCells()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        rootView.confirmButton.isEnabled = true
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    override func setupDelegate() {
        rootView.memberListView.dataSource = self
    }
}


// MARK: - Extension

private extension ChooseMemberViewController {
    func setupBinding() {
        viewModel.participantList?.bindOnMain(with: self, { owner, members in
            self.rootView.memberListView.reloadData()
        })
    }
    
    // TODO: 셀 초기 선택 안되는 문제 해결
    func setupSelectInitialCells() {
        DispatchQueue.main.async {
            guard let members = self.viewModel.participantList?.value else { return }
            
            for index in 0 ..< members.count {
                let indexPath = IndexPath(item: index, section: 0)
                
                if members[index].isParticipant {
                    (self.rootView.memberListView.cellForItem(at: indexPath) as? SelectMemberCell)?.isSelected = true
                }
            }
            
            self.rootView.memberListView.reloadData()
        }
    }
    
    @objc
    func confirmButtonDidTap() {
        let viewController = ChooseContentViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UICollectionViewDelegate

extension ChooseMemberViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.participantList?.value[indexPath.row].isParticipant = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.participantList?.value[indexPath.row].isParticipant = false
    }
}


// MARK: - UICollectionViewDataSource

extension ChooseMemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.participantList?.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMemberCell.reuseIdentifier, for: indexPath) as? SelectMemberCell else { return UICollectionViewCell() }
        
        cell.configure(
            with: Member(
                memberID: viewModel.participantList?.value[indexPath.row].memberID ?? 0,
                name: viewModel.participantList?.value[indexPath.row].name,
                profileImageURL: viewModel.participantList?.value[indexPath.row].profileImageURL
            )
        )
        
        return cell
    }
}