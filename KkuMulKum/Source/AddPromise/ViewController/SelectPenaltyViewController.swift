//
//  SelectPenaltyViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SelectPenaltyViewController: BaseViewController {
    private let viewModel: SelectPenaltyViewModel
    private let disposeBag = DisposeBag()
    private let rootView = SelectPenaltyView()
    private let selectedLevelButtonRelay = BehaviorRelay(value: "")
    private let selectedPenaltyButtonRelay = BehaviorRelay(value: "")
    
    
    // MARK: - Initializer
    
    init(viewModel: SelectPenaltyViewModel) {
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
    
    override func setupAction() {
        let levelButtonTaps = rootView.levelButtons.map { button in
            button.rx.tap.map { button }
        }
        
        let penaltyButtonTaps = rootView.penaltyButtons.map { button in
            button.rx.tap.map { button }
        }
        
        Observable.merge(levelButtonTaps)
            .subscribe(with: self) { owner, selectedButton in
                owner.updateLevelButtonColors(selectedButton)
                owner.selectedLevelButtonRelay.accept(selectedButton.identifier)
            }
            .disposed(by: disposeBag)
        
        Observable.merge(penaltyButtonTaps)
            .subscribe(with: self) { owner, selectedButton in
                owner.updatePenaltyButtonColors(selectedButton)
                owner.selectedPenaltyButtonRelay.accept(selectedButton.identifier)
            }
            .disposed(by: disposeBag)
    }
}

private extension SelectPenaltyViewController {
    func bindViewModel() {
        let input = SelectPenaltyViewModel.Input(
            selectedLevelButton: selectedLevelButtonRelay.asObservable(),
            selectedPenaltyButton: selectedPenaltyButtonRelay.asObservable(),
            confirmButtonDidTap: rootView.confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isEnabledConfirmButton
            .subscribe(with: self) { owner, flag in
                owner.rootView.confirmButton.isEnabled = flag
            }
            .disposed(by: disposeBag)
        
        output.isSucceedToCreate
            .drive(with: self) { owner, result in
                let (flag, promiseID) = result
                guard flag else { return }
                let viewController = AddPromiseCompleteViewController(promiseID: promiseID ?? 0)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func updateLevelButtonColors(_ selectedButton: UIButton) {
        for button in rootView.levelButtons {
            button.isSelected = button == selectedButton
        }
    }
    
    func updatePenaltyButtonColors(_ selectedButton: UIButton) {
        for button in rootView.penaltyButtons {
            button.isSelected = button == selectedButton
        }
    }
}
