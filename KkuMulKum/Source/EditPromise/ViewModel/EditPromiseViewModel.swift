//
//  EditPromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import Foundation

class EditPromiseViewModel {
    let promiseNameState = ObservablePattern<NameState>(.empty)
    let promiseID: Int
    let promiseName: ObservablePattern<String>?
    let placeName: ObservablePattern<String>?
    let participantList: ObservablePattern<[AvailableMember]>?
    let dressUpLevel: ObservablePattern<String>?
    let penalty: ObservablePattern<String>?
    
    var xCoordinate: Double?
    var yCoordinate: Double?
    var address: String?
    var roadAddress: String?
    var time: String?
    
    private let service: EditPromiseServiceProtocol
    
    
    // MARK: Initialize
    
    init(
        promiseID: Int,
        promiseName: String? = nil,
        placeName: String? = nil,
        xCoordinate: Double? = nil,
        yCoordinate: Double? = nil,
        address: String? = nil,
        roadAddress: String? = nil,
        time: String? = nil,
        participantList: [AvailableMember]? = nil,
        dressUpLevel: String? = nil,
        penalty: String? = nil,
        service: EditPromiseServiceProtocol
    ) {
        self.promiseID = promiseID
        self.promiseName = ObservablePattern<String>(promiseName ?? "")
        self.placeName = ObservablePattern<String>(placeName ?? "")
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
        self.address = address
        self.roadAddress = roadAddress
        self.time = time
        self.participantList = ObservablePattern<[AvailableMember]>(participantList ?? [])
        self.dressUpLevel = ObservablePattern<String>(dressUpLevel ?? "")
        self.penalty = ObservablePattern<String>(penalty ?? "")
        self.service = service
    }
}

extension EditPromiseViewModel {
    func validateName(_ name: String) {
        let regex = "^[가-힣a-zA-Z0-9 ]{1,10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        promiseName?.value = name
        
        switch name.count {
        case 0:
            promiseNameState.value = .empty
        case 1...10:
            promiseNameState.value = .valid
        default:
            promiseNameState.value = .invalid
        }
        
        if !predicate.evaluate(with: name) {
            promiseNameState.value = .invalid
        }
    }
    
    func updatePlaceInfo(place: Place) {
        placeName?.value = place.location
        address = place.address
        roadAddress = place.roadAddress
        xCoordinate = place.x
        yCoordinate = place.y
    }
    
    func updateDateInfo(date: Date, time: Date) {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var combinedComponents = DateComponents()
        
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = timeComponents.second
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        self.time = dateFormatter.string(from: calendar.date(from: combinedComponents)!)
    }
    
    func updateDressLevel(text: String) {
        dressUpLevel?.value = text
    }
    
    func updatePenaltyLevel(text: String) {
        penalty?.value = text
    }
}

extension EditPromiseViewModel {
    func putPromiseInfo(request: EditPromiseRequestModel, completion: @escaping () -> Void) {
        Task {
            do {
                let result = try await service.putPromiseInfo(with: promiseID, request: request)
                
                guard let success = result?.success,
                        success == true else {
                    return
                }
                
                completion()
            }
        }
    }
    
    func fetchPromiseAvailableMember(completion: @escaping () -> Void) {
        Task {
            do {
                let result = try await service.fetchPromiseAvailableMember(with: promiseID)
                
                guard let success = result?.success, success == true else {
                    return
                }
                
                participantList?.value = result?.data?.members ?? []
                
                completion()
            }
        }
    }

    
    func deletePromise() {
        Task {
            do {
                let result = try await service.deletePromise(promiseID: promiseID)
                
                guard let success = result?.success, success == true else {
                    return
                }
            }
        }
    }
    
    func exitPromise() {
        Task {
            do {
                let result = try await service.exitPromise(promiseID: promiseID)
                
                guard let success = result?.success, success == true else {
                    return
                }
            }
        }
    }
}
