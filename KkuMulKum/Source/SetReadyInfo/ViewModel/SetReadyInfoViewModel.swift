//
//  SetReadyInfoViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/15/24.
//

import Foundation
import UserNotifications

import RxCocoa
import RxSwift

enum Time {
    case hour
    case minute
}

final class SetReadyInfoViewModel {
    let promiseID: Int
    let promiseName: String
    let promiseTime: String
    
    let errMessageRelay = PublishRelay<String>()
    let isSucceedRelay = BehaviorRelay<Bool>(value: false)
    
    let readyHourRelay = BehaviorRelay<String>(value: "")
    let readyMinuteRelay = BehaviorRelay<String>(value: "")
    let moveHourRelay = BehaviorRelay<String>(value: "")
    let moveMinuteRelay = BehaviorRelay<String>(value: "")
    
    var storedReadyHour: String = ""
    var storedReadyMinute: String = ""
    var storedMoveHour: String = ""
    var storedMoveMinute: String = ""
    
    var readyTime: Int = 0
    var moveTime: Int = 0
    
    let bufferTime: TimeInterval = 10 * 60
    
    private let service: SetReadyStatusInfoServiceType
    private let notificationManager: LocalNotificationManager
    
    init(
        promiseID: Int,
        promiseTime: String,
        promiseName: String,
        storedReadyHour: String = "",
        storedReadyMinute: String = "",
        storedMoveHour: String = "",
        storedMoveMinute: String = "",
        service: SetReadyStatusInfoServiceType,
        notificationManager: LocalNotificationManager = LocalNotificationManager.shared
    ) {
        self.promiseID = promiseID
        self.promiseName = promiseName
        self.promiseTime = promiseTime
        self.storedReadyHour = storedReadyHour
        self.storedReadyMinute = storedReadyMinute
        self.storedMoveHour = storedMoveHour
        self.storedMoveMinute = storedMoveMinute
        self.service = service
        self.notificationManager = notificationManager
    }
    
    func setupStroredTime() {
        readyHourRelay.accept(storedReadyHour)
        readyMinuteRelay.accept(storedReadyMinute)
        moveHourRelay.accept(storedMoveHour)
        moveMinuteRelay.accept(storedMoveMinute)
    }
}

extension SetReadyInfoViewModel: ViewModelType {
    struct Input {
        let readyHourText: Observable<String>
        let readyMinuteText: Observable<String>
        let moveHourText: Observable<String>
        let moveMinuteText: Observable<String>
        let doneButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let readyHourText: Driver<String>
        let readyMinuteText: Driver<String>
        let moveHourText: Driver<String>
        let moveMinuteText: Driver<String>
        let errMessage: Driver<String>
        let doneButtonIsEnabled: Driver<Bool>
        let isSucceed: Driver<Bool>
    }
    
    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.readyHourText
            .distinctUntilChanged()
            .bind(to: readyHourRelay)
            .disposed(by: disposeBag)
        
        input.readyMinuteText
            .distinctUntilChanged()
            .bind(to: readyMinuteRelay)
            .disposed(by: disposeBag)
        
        input.moveHourText
            .distinctUntilChanged()
            .bind(to: moveHourRelay)
            .disposed(by: disposeBag)
        
        input.moveMinuteText
            .distinctUntilChanged()
            .bind(to: moveMinuteRelay)
            .disposed(by: disposeBag)
        
        input.doneButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.updateReadyInfo()
            }
            .disposed(by: disposeBag)
        
        let readyHourText = checkValidTime(time: .hour, relay: readyHourRelay)
        let readyMinuteText = checkValidTime(time: .minute, relay: readyMinuteRelay)
        let moveHourText = checkValidTime(time: .hour, relay: moveHourRelay)
        let moveMinuteText = checkValidTime(time: .minute, relay: moveMinuteRelay)
        
        let errMessage = errMessageRelay.asDriver(onErrorJustReturn: "")
        
        let doneButtonIsEnabled = Observable.combineLatest(
            readyHourRelay.map { !$0.isEmpty },
            readyMinuteRelay.map { !$0.isEmpty },
            moveHourRelay.map { !$0.isEmpty },
            moveMinuteRelay.map { !$0.isEmpty }
        )
            .map { $0 && $1 && $2 && $3 }
            .asDriver(onErrorJustReturn: false)
        
        let isSucceed = isSucceedRelay.asDriver(onErrorJustReturn: false)
        
        let output = Output(
            readyHourText: readyHourText,
            readyMinuteText: readyMinuteText,
            moveHourText: moveHourText,
            moveMinuteText: moveMinuteText,
            errMessage: errMessage,
            doneButtonIsEnabled: doneButtonIsEnabled,
            isSucceed: isSucceed
        )
        
        return output
    }
}

private extension SetReadyInfoViewModel {
    func checkValidTime(time: Time, relay: BehaviorRelay<String>) -> Driver<String> {
        let range: ClosedRange<Int> = time == .hour ? 0...23 : 0...59
        return relay
            .map { value in
                if value.isEmpty {
                    return ""
                } else if let intValue = Int(value), range.contains(intValue) {
                    return value.description
                } else {
                    self.errMessageRelay.accept("시간은 23시간 59분까지만 입력할 수 있어요!")
                    return String(range.upperBound)
                }
            }
            .asDriver(onErrorJustReturn: "")
    }
    
    func calculateTotalTime() {
        guard let readyHour = Int(readyHourRelay.value) else { return }
        guard let readyMinute = Int(readyMinuteRelay.value) else { return }
        guard let moveHour = Int(moveHourRelay.value) else { return }
        guard let moveMinute = Int(moveMinuteRelay.value) else { return }
        
        readyTime = readyHour * 60 + readyMinute
        moveTime = moveHour * 60 + moveMinute
    }
    
    func updateReadyInfo() {
        calculateTotalTime()
        scheduleLocalNotification()
        
        Task {
            let model = MyPromiseReadyInfoModel(
                preparationTime: readyTime,
                travelTime: moveTime
            )
            
            do {
                guard let responseBody = try await service.updateMyPromiseReadyStatus(
                    with: promiseID,
                    requestModel: model
                ) else {
                    isSucceedRelay.accept(false)
                    return
                }
                isSucceedRelay.accept(responseBody.success)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}

private extension SetReadyInfoViewModel {
    func scheduleLocalNotification() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
       
        guard let promiseDate = dateFormatter.date(from: self.promiseTime) else {
            print("Invalid date format: \(self.promiseTime)")
            return
        }
        
        let totalPrepTime = TimeInterval((self.readyTime + self.moveTime) * 60)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        print("약속 시간: \(timeFormatter.string(from: promiseDate))")
        print("준비 시간: \(self.readyTime) 분")
        print("이동 시간: \(self.moveTime) 분")
        print("총 준비 시간: \(totalPrepTime / 60) 분")
        
        let readyStartTime = promiseDate.addingTimeInterval(-(totalPrepTime + bufferTime))
        let moveStartTime = promiseDate.addingTimeInterval(-(TimeInterval(self.moveTime * 60) + bufferTime))
        
        print("준비 시작 시간: \(timeFormatter.string(from: readyStartTime))")
        print("이동 시작 시간: \(timeFormatter.string(from: moveStartTime))")
        
        self.notificationManager.requestAuthorization { [weak self] granted in
            guard let self = self else { return }
            if granted {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    print("현재 알림 설정: \(settings)")
                }
                
                self.notificationManager.removeAllPendingNotifications()
                
                self.notificationManager.scheduleNotification(
                    title: "준비 시작",
                    body: "\(self.promiseName) 약속 준비를 시작할 시간입니다!",
                    triggerDate: readyStartTime,
                    identifier: "readyStart_\(self.promiseID)"
                ) { error in
                    if let error = error {
                        print("준비 시작 알림 설정 실패: \(error)")
                    } else {
                        print("준비 시작 알림이 \(timeFormatter.string(from: readyStartTime))에 설정되었습니다.")
                    }
                }
                
                self.notificationManager.scheduleNotification(
                    title: "이동 시작",
                    body: "\(self.promiseName) 약속 장소로 이동할 시간입니다!",
                    triggerDate: moveStartTime,
                    identifier: "moveStart_\(self.promiseID)"
                ) { error in
                    if let error = error {
                        print("이동 시작 알림 설정 실패: \(error)")
                    } else {
                        print("이동 시작 알림이 \(timeFormatter.string(from: moveStartTime))에 설정되었습니다.")
                    }
                }
                
                self.notificationManager.getPendingNotifications { requests in
                    print("예정된 알림 수: \(requests.count)")
                    for request in requests {
                        if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                           let nextTriggerDate = trigger.nextTriggerDate() {
                            print("알림 ID: \(request.identifier), 예정 시간: \(timeFormatter.string(from: nextTriggerDate))")
                        }
                    }
                }
            } else {
                print("알림 권한이 허용되지 않았습니다.")
            }
        }
    }
}
