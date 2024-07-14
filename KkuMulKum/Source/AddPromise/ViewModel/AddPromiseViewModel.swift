//
//  AddPromiseViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import Foundation

import RxCocoa
import RxSwift

enum PromiseNameState {
    case basic
    case success
    case failure
}

final class AddPromiseViewModel {
    private let meetingID: Int
    private let service: AddPromiseServiceType
    
    init(meetingID: Int, service: AddPromiseServiceType) {
        self.meetingID = meetingID
        self.service = service
    }
}

extension AddPromiseViewModel: ViewModelType {
    struct Input {
        let promiseNameTextFieldDidChange: Observable<String?>
        let promiseTextFieldEndEditing: PublishRelay<Void>
        let promisePlaceTextFieldDidTap: PublishRelay<Void>
    }
    
    struct Output {
        let validateNameEditing: Driver<PromiseNameState>
        let validateNameEndEditing: Driver<PromiseNameState>
        let searchPlace: Driver<Void>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let promiseTextFieldRelay = BehaviorRelay<String?>(value: nil)
        
        input.promiseNameTextFieldDidChange
            .bind(to: promiseTextFieldRelay)
            .disposed(by: disposeBag)
        
        let validateName: (String?) -> PromiseNameState = { value in
            guard let name = value,
                  !name.isEmpty
            else {
                return .basic
            }
            
            let regex = "^[가-힣a-zA-Z0-9 ]{1,10}$"
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            
            return predicate.evaluate(with: name) ? .success : .failure
        }
        
        let validateNameEditing = promiseTextFieldRelay
            .map(validateName)
            .asDriver(onErrorJustReturn: .failure)
        
        let validateNameEndEditing = input.promiseTextFieldEndEditing
            .withLatestFrom(promiseTextFieldRelay)
            .map(validateName)
            .map { state -> PromiseNameState in
                switch state {
                case .basic, .success:
                    return .basic
                case .failure:
                    return .failure
                }
            }
            .asDriver(onErrorJustReturn: .failure)
        
        let searchPlace = input.promisePlaceTextFieldDidTap
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        let output = Output(
            validateNameEditing: validateNameEditing, 
            validateNameEndEditing: validateNameEndEditing,
            searchPlace: searchPlace
        )
        
        return output
    }
}
