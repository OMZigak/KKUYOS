//
//  SelectMemberViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SelectMemberViewController: BaseViewController {
    private let viewModel: SelectMemberViewModel
    private let disposeBag = DisposeBag()
    private let rootView = SelectMemberView()
    private let viewWillAppearRelay = PublishRelay<Void>()
    private let memberSelected = PublishSubject<Member>()
    private let memberDeselected = PublishSubject<Member>()
    
    
    // MARK: - Initializer

    init(viewModel: SelectMemberViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle(with: "약속 추가하기")
        setupNavigationBarBackButton()
        
        bindViewModel()
    }
    
    override func setupAction() {
        rootView.confirmButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let viewController = SelectPenaltyViewController(
                    viewModel: SelectPenaltyViewModel(
                        meetingID: owner.viewModel.meetingID,
                        name: owner.viewModel.name,
                        place: owner.viewModel.place,
                        dateString: owner.viewModel.promiseDateString,
                        members: owner.viewModel.members,
                        service: PromiseService()
                    )
                )
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setupDelegate() {
        rootView.memberListView.delegate = self
    }
}


// MARK: - UICollectionViewDelegate

extension SelectMemberViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMember = viewModel.members[indexPath.item]
        memberSelected.onNext(selectedMember)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectedMember = viewModel.members[indexPath.item]
        memberDeselected.onNext(deselectedMember)
    }
}

private extension SelectMemberViewController {
    func bindViewModel() {
        let input = SelectMemberViewModel.Input(
            viewDidLoad: .just(()),
            memberSelected: memberSelected.asObservable(),
            memberDeselected: memberDeselected.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.memberList
            .drive(rootView.memberListView.rx.items(
                    cellIdentifier: SelectMemberCell.reuseIdentifier,
                    cellType: SelectMemberCell.self
            )) { index, member, cell in
                cell.configure(with: member)
            }
            .disposed(by: disposeBag)
        
        output.isEnabledConfirmButton
            .drive(with: self) { owner, flag in
                owner.rootView.confirmButton.isEnabled = flag
            }
            .disposed(by: disposeBag)
    }
}
