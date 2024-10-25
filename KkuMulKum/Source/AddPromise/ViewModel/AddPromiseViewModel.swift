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
    private let meetingID: Int
    
    init(meetingID: Int) {
        self.meetingID = meetingID
    }
}

extension AddPromiseViewModel: ViewModelType {
    struct Input {
        let promiseNameText: Observable<String>
        let promiseTextFieldEndEditing: Observable<Void>
        let date: Observable<Date>
        let time: Observable<Date>
        let place: Observable<Place>
        let confirmButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let validationPromiseNameResult: Observable<TextFieldVailidationResult>
        let isEnabledConfirmButton: Observable<Bool>
        let adjustedDate: Observable<Date>
        let navigateToSelectMember: Observable<AddPromiseRequestModel.Builder>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let placeRelay = BehaviorRelay<Place?>(value: nil)
        
        let isValid = input.promiseNameText
            .map { [weak self] text in
                if text.isEmpty {
                    return false
                }
                
                return self?.validate(text: text) ?? false
            }
        
        let validationResultWhileEditing = input.promiseNameText
            .map { [weak self] text -> TextFieldVailidationResult in
                guard let self else {
                    return .basic
                }
                
                if text.isEmpty {
                    return .basic
                }
                
                if validate(text: text) {
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
        
        let combinedDateTime = Observable.combineLatest(input.date, input.time)
            .map { [weak self] date, time -> String in
                return self?.combine(date: date, time: time) ?? ""
            }
        
        input.place
            .bind(to: placeRelay)
            .disposed(by: disposeBag)
        
        let isEnabledConfirmButton = Observable.combineLatest(isValid, placeRelay)
            .map { flag, place -> Bool in
                return flag && place != nil
            }
        
        let adjustedDate = Observable.combineLatest(input.date, input.time)
            .map { date, time -> Date in
                let calendar = Calendar.current
                
                guard let tempDate = calendar.date(byAdding: .minute, value: -1, to: Date()) else {
                    return Date()
                }
                
                if calendar.component(.day, from: date) == calendar.component(.day, from: tempDate),
                   time < tempDate {
                    return Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
                }
                return date
            }
        
        let navigateToSelectMember = input.confirmButtonDidTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.promiseNameText,
                    combinedDateTime,
                    input.place
                )
            )
            .compactMap { [weak self] name, time, place -> AddPromiseRequestModel.Builder? in
                guard let self else {
                    return nil
                }
                
                return AddPromiseRequestModel.Builder()
                    .setId(meetingID)
                    .setName(name)
                    .setTime(time)
                    .setPlaceName(place.location)
                    .setAddress(place.address ?? "")
                    .setRoadAddress(place.roadAddress ?? "")
                    .setCoordinates(x: place.x, y: place.y)
            }
            
        return Output(
            validationPromiseNameResult: validationPromiseNameResult,
            isEnabledConfirmButton: isEnabledConfirmButton, 
            adjustedDate: adjustedDate,
            navigateToSelectMember: navigateToSelectMember
        )
    }
}

private extension AddPromiseViewModel {
    func validate(text: String) -> Bool {
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
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: combinedDate)
    }
}
