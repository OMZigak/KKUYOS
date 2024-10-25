//
//  SelectPenaltyViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/17/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SelectPenaltyViewModel {
    private let builder: AddPromiseRequestModel.Builder
    private let service: SelectPenaltyServiceType
    private let newPromiseRelay = BehaviorRelay<AddPromiseResponseModel?>(value: nil)
    
    init(
        builder: AddPromiseRequestModel.Builder,
        service: SelectPenaltyServiceType
    ) {
        self.builder = builder
        self.service = service
    }
}

extension SelectPenaltyViewModel: ViewModelType {
    struct Input {
        let selectedLevelButton: Observable<String>
        let selectedPenaltyButton: Observable<String>
        let confirmButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isEnabledConfirmButton: Observable<Bool>
        let isSucceedToCreate: Driver<Int>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isEnabledConfirmButton = Observable.combineLatest(
            input.selectedLevelButton, input.selectedPenaltyButton
        ).map { !$0.isEmpty && !$1.isEmpty }
        
        input.confirmButtonDidTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.selectedLevelButton,
                    input.selectedPenaltyButton
                )
            )
            .subscribe(with: self) { [weak self] owner, values in
                let (level, penalty) = values
                self?.builder
                    .setDressUpLevel(level)
                    .setPenalty(penalty)
                
                self?.requestAddNewPromise()
            }
            .disposed(by: disposeBag)
       
        let isSucceedToCreate = newPromiseRelay
            .compactMap { $0?.promiseID }
            .asDriver(onErrorJustReturn: -1)
        
        let output = Output(
            isEnabledConfirmButton: isEnabledConfirmButton,
            isSucceedToCreate: isSucceedToCreate
        )
        
        return output
    }
}

private extension SelectPenaltyViewModel {
    func requestAddNewPromise() {
        Task {
            do {
                guard let responseBody = try await service.requestAddingNewPromise(
                    with: builder.build(),
                    meetingID: builder.id
                ),
                      responseBody.success
                else {
                    newPromiseRelay.accept(nil)
                    return
                }
                newPromiseRelay.accept(responseBody.data)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
