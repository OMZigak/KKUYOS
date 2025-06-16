//
//  AddPromiseRequestModelBuilder.swift
//  KkuMulKum
//
//  Created by 김진웅 on 10/25/24.
//

import Foundation

extension AddPromiseRequestModel {
    final class Builder {
        private(set) var id = 0
        private var name = ""
        private var placeName = ""
        private var address = ""
        private var roadAddress = ""
        private var time = ""
        private var dressUpLevel = ""
        private var penalty = ""
        private var x = 0.0
        private var y = 0.0
        private var participants = [Int]()
        
        @discardableResult
        func setName(_ name: String) -> Self {
            self.name = name
            return self
        }
        
        @discardableResult
        func setPlaceName(_ placeName: String) -> Self {
            self.placeName = placeName
            return self
        }
        
        @discardableResult
        func setAddress(_ address: String) -> Self {
            self.address = address
            return self
        }
        
        @discardableResult
        func setRoadAddress(_ roadAddress: String) -> Self {
            self.roadAddress = roadAddress
            return self
        }
        
        @discardableResult
        func setTime(_ time: String) -> Self {
            self.time = time
            return self
        }
        
        @discardableResult
        func setDressUpLevel(_ dressUpLevel: String) -> Self {
            self.dressUpLevel = dressUpLevel
            return self
        }
        
        @discardableResult
        func setPenalty(_ penalty: String) -> Self {
            self.penalty = penalty
            return self
        }
        
        @discardableResult
        func setCoordinates(x: Double, y: Double) -> Self {
            self.x = x
            self.y = y
            return self
        }
        
        @discardableResult
        func setId(_ id: Int) -> Self {
            self.id = id
            return self
        }
        
        @discardableResult
        func setParticipants(_ participants: [Int]) -> Self {
            self.participants = participants
            return self
        }
        
        func build() -> AddPromiseRequestModel {
            return AddPromiseRequestModel(
                name: name,
                placeName: placeName,
                address: address,
                roadAddress: roadAddress,
                time: time,
                dressUpLevel: dressUpLevel,
                penalty: penalty,
                x: x,
                y: y,
                id: id,
                participants: participants
            )
        }
    }
}
