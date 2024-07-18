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
        let textFieldDidChange: Observable<String>
        let textFieldEndEditing: PublishRelay<Void>
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
        let isEndEditingTextField = input.textFieldEndEditing
            .map { true }
            .asDriver(onErrorJustReturn: false)
        
        input.textFieldEndEditing
            .withLatestFrom(input.textFieldDidChange)
            .subscribe(with: self) { owner, text in
                owner.fetchPlaceList(with: text)
            }
            .disposed(by: disposeBag)
        
        let placeList = placeListRelay
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
        
        input.cellIsSelected
            .bind(to: selectedPlaceRelay)
            .disposed(by: disposeBag)
        
        let isEnabledConfirmButton = selectedPlaceRelay
            .map { place -> Bool in
                place != nil
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

private extension FindPlaceViewModel {
    func fetchPlaceList(with input: String) {
        Task {
            do {
                guard let responseBody = try await self.service.fetchPlaceList(with: input),
                      let places = responseBody.data
                else {
                    return
                }
                placeListRelay.accept(places)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
