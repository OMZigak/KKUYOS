//
//  AddPromiseViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import Foundation

import RxCocoa
import RxSwift

enum TextFieldVailidationResult {
    case basic, onWriting, error
}

final class AddPromiseViewModel {
    let meetingID: Int
    
    var place: Place? { placeRelay.value }
    var combinedDateTime: String { combinedDateTimeRelay.value }
    
    private let service: AddPromiseServiceType
    private let combinedDateTimeRelay = BehaviorRelay(value: "")
    private let placeRelay = BehaviorRelay<Place?>(value: nil)
    
    init(meetingID: Int, service: AddPromiseServiceType) {
        self.meetingID = meetingID
        self.service = service
    }
}

extension AddPromiseViewModel: ViewModelType {
    struct Input {
        let promiseNameText: Observable<String>
        let promiseTextFieldEndEditing: Observable<Void>
        let date: Observable<Date>
        let time: Observable<Date>
        let place: PublishRelay<Place>
    }
    
    struct Output {
        let validationPromiseNameResult: Observable<TextFieldVailidationResult>
        let isEnabledConfirmButton: Observable<Bool>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let isValid = input.promiseNameText
            .map { [weak self] text in
                return !text.isEmpty && self?.isValid(text: text) ?? false
            }
        
        let validationResultWhileEditing = input.promiseNameText
            .map { text -> TextFieldVailidationResult in
                if text.isEmpty {
                    return .basic
                }
                
                if self.isValid(text: text) {
                    return .onWriting
                }
                
                return .error
            }
        
        let validationResultAfterEditing = input.promiseTextFieldEndEditing
            .withLatestFrom(isValid)
            .map { flag -> TextFieldVailidationResult in
                return flag ? .basic : .error
            }
        
        let validationPromiseNameResult = Observable.merge(
            validationResultWhileEditing, validationResultAfterEditing
        )
        
        Observable.combineLatest(input.date, input.time)
            .map { [weak self] date, time -> String in
                return self?.combine(date: date, time: time) ?? ""
            }
            .bind(to: combinedDateTimeRelay)
            .disposed(by: disposeBag)
        
        input.place
            .bind(to: placeRelay)
            .disposed(by: disposeBag)
        
        let isEnabledConfirmButton = Observable.combineLatest(isValid, placeRelay)
            .map { flag, place -> Bool in
                return flag && place != nil
            }
        
        return Output(
            validationPromiseNameResult: validationPromiseNameResult,
            isEnabledConfirmButton: isEnabledConfirmButton
        )
    }
}

private extension AddPromiseViewModel {
    func isValid(text: String) -> Bool {        
        let regex = "^[가-힣a-zA-Z0-9 ]{1,10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: text)
    }
    
    func combine(date: Date, time: Date) -> String {
        let calendar = Calendar.current
        var combinedComponents = DateComponents()
        combinedComponents.year = calendar.component(.year, from: date)
        combinedComponents.month = calendar.component(.month, from: date)
        combinedComponents.day = calendar.component(.day, from: date)
        combinedComponents.hour = calendar.component(.hour, from: time)
        combinedComponents.minute = calendar.component(.minute, from: time)
        combinedComponents.second = calendar.component(.second, from: time)
        
        guard let combinedDate = calendar.date(from: combinedComponents) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: combinedDate)
    }
}
