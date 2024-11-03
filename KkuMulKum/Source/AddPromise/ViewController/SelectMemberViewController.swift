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
    private let viewWillAppearRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let rootView = SelectMemberView()
    
    
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
        
        setupNavigationBarTitle(with: "약속 추가하기", isBorderHidden: true)
        setupNavigationBarBackButton()
        
        bindViewModel()
    }
}

private extension SelectMemberViewController {
    func bindViewModel() {
        let memberSelected = rootView.memberListView.rx.itemSelected
            .map { $0.item }
        let memberDeselected = rootView.memberListView.rx.itemDeselected
            .map { $0.item }
        
        let input = SelectMemberViewModel.Input(
            viewDidLoad: .just(()),
            memberSelected: memberSelected.asObservable(),
            memberDeselected: memberDeselected.asObservable(),
            confirmButtonDidTap: rootView.confirmButton.rx.tap.asObservable()
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
        
        output.memberList
            .map { $0.isEmpty }
            .drive(with: self) { owner, flag in
                owner.rootView.memberListView.isHidden = flag
                owner.rootView.emptyContentView.isHidden = !flag
            }
            .disposed(by: disposeBag)
        
        output.navigateToSelectPenalty
            .subscribe(with: self) { owner, builder in
                let viewController = SelectPenaltyViewController(
                    viewModel: SelectPenaltyViewModel(
                        builder: builder,
                        service: PromiseService()
                    )
                )
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
