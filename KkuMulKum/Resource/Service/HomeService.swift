//
//  HomeService.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/16/24.
//

import Foundation

protocol HomeServiceType {
    func fetchLoginUser() -> LoginUserModel?
    func fetchNearestPromise() -> NearestPromiseModel?
    func fetchUpcomingPromise() -> UpcomingPromiseListModel?
}

final class MockHomeService: HomeServiceType {
    func fetchLoginUser() -> LoginUserModel? {
        let mockData = LoginUserModel(
            name: "꾸물리안",
            level: 4,
            promiseCount: 8,
            tardyCount: 2,
            tardySum: 72,
            profileImageURL: ""
        )
        return mockData
    }
    
    func fetchNearestPromise() -> NearestPromiseModel? {
        let mockData = NearestPromiseModel(
            id: 1,
            dDay: 0,
            name: "꾸물이들의 냐미한 밤",
            meetingName: "꾸물이들",
            dressUpLevel: "냐미",
            date: "2024.07.16",
            time: "PM 8:00",
            placeName: "DMC역"
        )
        return mockData
    }
    
    func fetchUpcomingPromise() -> UpcomingPromiseListModel? {
        let mockData = UpcomingPromiseListModel(
            promises: [
                UpcomingPromise(
                    id: 1,
                    dDay: 1,
                    name: "누가 코코볼 다 먹었어?",
                    meetingName: "우마우스",
                    dressUpLevel: "",
                    date: "2024.07.17",
                    time: "PM 2:00",
                    placeName: "가자하우스"
                ),
                UpcomingPromise(
                    id: 2,
                    dDay: 1,
                    name: "누가 코코볼 다 먹었어?",
                    meetingName: "우마우스",
                    dressUpLevel: "",
                    date: "2024.07.17",
                    time: "PM 2:00",
                    placeName: "가자하우스"
                ),
                UpcomingPromise(
                    id: 3,
                    dDay: 1,
                    name: "누가 코코볼 다 먹었어?",
                    meetingName: "우마우스",
                    dressUpLevel: "",
                    date: "2024.07.17",
                    time: "PM 2:00",
                    placeName: "가자하우스"
                ),
                UpcomingPromise(
                    id: 4,
                    dDay: 1,
                    name: "누가 코코볼 다 먹었어?",
                    meetingName: "우마우스",
                    dressUpLevel: "",
                    date: "2024.07.17",
                    time: "PM 2:00",
                    placeName: "가자하우스"
                )
            ]
        )
        return mockData
    }
}
