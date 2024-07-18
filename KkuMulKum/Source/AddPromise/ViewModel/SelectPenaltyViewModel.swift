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
    let meetingID: Int
    let name: String
    let place: Place
    let dateString: String
    let members: [Member]
    
    private let service: SelectPenaltyServiceType
    private let levelRelay = BehaviorRelay(value: "")
    private let penaltyRelay = BehaviorRelay(value: "")
    private let newPromiseRelay = BehaviorRelay<AddPromiseResponseModel?>(value: nil)
    
    init(
        meetingID: Int,
        name: String,
        place: Place,
        dateString: String,
        members: [Member],
        service: SelectPenaltyServiceType
    ) {
        self.meetingID = meetingID
        self.name = name
        self.place = place
        self.dateString = dateString
        self.members = members
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
        let isSucceedToCreate: Driver<(Bool, Int?)>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isEnabledConfirmButton = Observable.combineLatest(
            input.selectedLevelButton, input.selectedPenaltyButton
        ).map { !$0.isEmpty && !$1.isEmpty }
        
        input.selectedLevelButton
            .bind(to: levelRelay)
            .disposed(by: disposeBag)
        
        input.selectedPenaltyButton
            .bind(to: penaltyRelay)
            .disposed(by: disposeBag)
        
        input.confirmButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.requestAddNewPromise()
            }
            .disposed(by: disposeBag)
       
        let isSucceedToCreate = newPromiseRelay
            .map { promise -> (Bool, Int?) in
                guard let promise else {
                    return (false, nil)
                }
                return (true, promise.promiseID)
            }
            .asDriver(onErrorJustReturn: (false, nil))
        
        let output = Output(
            isEnabledConfirmButton: isEnabledConfirmButton,
            isSucceedToCreate: isSucceedToCreate
        )
        
        return output
    }
}

private extension SelectPenaltyViewModel {
    func createAddPromiseModel() -> AddPromiseRequestModel {
        let addPromiseModel = AddPromiseRequestModel(
            name: name,
            placeName: place.location,
            address: place.address ?? "",
            roadAddress: place.roadAddress ?? "",
            time: dateString,
            dressUpLevel: levelRelay.value,
            penalty: penaltyRelay.value,
            x: place.x,
            y: place.y,
            id: meetingID,
            participants: members.map { $0.memberID }
        )
        
        return addPromiseModel
    }
    
    func requestAddNewPromise() {
        Task {
            do {
                guard let responseBody = try await service.requestAddingNewPromise(
                    with: createAddPromiseModel(),
                    meetingID: meetingID
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
