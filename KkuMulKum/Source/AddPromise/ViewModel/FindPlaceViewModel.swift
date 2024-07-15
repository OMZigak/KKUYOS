//
//  FindPlaceViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class FindPlaceViewModel {
    private let service: FindPlaceServiceType
    private let userInputRelay = BehaviorRelay<String?>(value: nil)
    private let placeListRelay = BehaviorRelay<[Place]?>(value: nil)
    private let selectedPlaceRelay = BehaviorRelay<Place?>(value: nil)
    
    init(service: FindPlaceServiceType) {
        self.service = service
    }
}

extension FindPlaceViewModel: ViewModelType {
    struct Input {
        let textFieldDidChange: Observable<String?>
        let textFieldEneEditing: PublishRelay<Void>
        let cellIsSelected: PublishRelay<Place?>
        let confirmButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isEndEditingTextField: Driver<Bool>
        let placeList: Driver<[Place]>
        let isEnabledConfirmButton: Driver<Bool>
        let popViewController: Driver<Place?>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isEndEditingTextField = input.textFieldEneEditing
            .map { true }
            .asDriver(onErrorJustReturn: false)
        
        input.textFieldEneEditing
            .withLatestFrom(input.textFieldDidChange)
            .map { [weak self] text -> [Place] in
                guard let text,
                      !text.isEmpty,
                      let placeModel = self?.service.fetchPlaceList(with: text)
                else {
                    return []
                }
                return placeModel.places
            }
            .bind(to: placeListRelay)
            .disposed(by: disposeBag)
        
        let placeList = placeListRelay
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
            
        input.cellIsSelected
            .bind(to: selectedPlaceRelay)
            .disposed(by: disposeBag)
        
        let isEnabledConfirmButton = selectedPlaceRelay
            .map { place -> Bool in
                place != nil ? true : false
            }
            .asDriver(onErrorJustReturn: false)
        
        let popViewController = input.confirmButtonDidTap
            .withLatestFrom(selectedPlaceRelay)
            .map { $0 }
            .asDriver(onErrorJustReturn: nil)
        
        let output = Output(
            isEndEditingTextField: isEndEditingTextField,
            placeList: placeList,
            isEnabledConfirmButton: isEnabledConfirmButton,
            popViewController: popViewController
        )
        
        return output
    }
}
