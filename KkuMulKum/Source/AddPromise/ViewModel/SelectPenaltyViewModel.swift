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
        let isSucceedToCreate: Driver<Bool>
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
       
        let isSucceedToCreate = input.confirmButtonDidTap
            .map { [weak self] _ -> Bool in
                guard let self else { return false }
                let result = service.requestCreateNewPromise(with: createAddPromiseModel())
                return result.success
            }
            .asDriver(onErrorJustReturn: false)
        
        let output = Output(
            isEnabledConfirmButton: isEnabledConfirmButton,
            isSucceedToCreate: isSucceedToCreate
        )
        
        return output
    }
}

private extension SelectPenaltyViewModel {
    func createAddPromiseModel() -> AddPromiseModel {
        let addPromiseModel = AddPromiseModel(
            name: name,
            placeName: place.location,
            x: "\(place.x)",
            y: "\(place.y)",
            address: place.address ?? "",
            roadAddress: place.roadAddress ?? "",
            time: dateString,
            dressUpLevel: levelRelay.value,
            penalty: penaltyRelay.value,
            id: meetingID,
            participants: members.map { $0.id }
        )
        
        return addPromiseModel
    }
}
