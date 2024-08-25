//
//  EditPromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

class EditPromiseViewModel {
    let promiseNameState = ObservablePattern<NameState>(.empty)
    let promiseID: Int
    let promiseName: ObservablePattern<String>?
    let placeName: String?
    let xCoordinate: Double?
    let yCoordinate: Double?
    let address: String?
    let roadAddress: String?
    let time: String?
    let participantList: [Int]?
    let dressUpLevel: String?
    let penalty: String?
    
    
    
    // MARK: Initialize
    
    init(
        promiseID: Int,
        promiseName: ObservablePattern<String>? = nil,
        placeName: String? = nil,
        xCoordinate: Double? = nil,
        yCoordinate: Double? = nil,
        address: String? = nil,
        roadAddress: String? = nil,
        time: String? = nil,
        participantList: [Int]? = nil,
        dressUpLevel: String? = nil,
        penalty: String? = nil
    ) {
        self.promiseID = promiseID
        self.promiseName = promiseName
        self.placeName = placeName
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
        self.address = address
        self.roadAddress = roadAddress
        self.time = time
        self.participantList = participantList
        self.dressUpLevel = dressUpLevel
        self.penalty = penalty
    }
}

extension EditPromiseViewModel {
    func validateName(_ name: String) {
        promiseName?.value = name
        
        switch name.count {
        case 0:
            promiseNameState.value = .empty
        case 1...10:
            promiseNameState.value = .valid
        default:
            promiseNameState.value = .invalid
        }
    }
}
