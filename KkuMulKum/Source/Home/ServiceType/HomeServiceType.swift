//
//  HomeServiceType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

protocol HomeServiceType {
    func fetchLoginUser() -> ResponseBodyDTO<LoginUserModel>
    func fetchNearestPromise() -> ResponseBodyDTO<NearestPromiseModel>
    func fetchUpcomingPromise() -> ResponseBodyDTO<UpcomingPromiseListModel>
}

final class MockHomeService: HomeServiceType {
    func fetchLoginUser() -> ResponseBodyDTO<LoginUserModel> {
        let mockData = ResponseBodyDTO<LoginUserModel>(
            success: true,
            data: LoginUserModel(
                userID: 1,
                name: "꾸물리안",
                level: 4,
                promiseCount: 8,
                tardyCount: 2,
                tardySum: 72,
                profileImageURL: ""
            ),
            error: nil
        )
        return mockData
    }
    
    func fetchNearestPromise() -> ResponseBodyDTO<NearestPromiseModel> {
        let mockData = ResponseBodyDTO<NearestPromiseModel>(
            success: true,
            data: NearestPromiseModel(
                promiseID: 1,
                dDay: 0,
                name: "꾸물이들 대환장 파티",
                meetingName: "꾸물이들",
                dressUpLevel: "냐미",
                date: "2024.07.16",
                time: "PM 8:00",
                placeName: "DMC역"
            ),
            error: nil
        )
        return mockData
    }
    
    func fetchUpcomingPromise() -> ResponseBodyDTO<UpcomingPromiseListModel> {
        let mockData = ResponseBodyDTO<UpcomingPromiseListModel>(
            success: true,
            data: UpcomingPromiseListModel(
                promises: [
                    UpcomingPromise(
                        promiseID: 1,
                        dDay: 1,
                        name: "누가 코코볼 다 먹었어?",
                        meetingName: "우마우스",
                        dressUpLevel: "",
                        date: "2024.07.17",
                        time: "PM 2:00",
                        placeName: "가자하우스"
                    ),
                    UpcomingPromise(
                        promiseID: 2,
                        dDay: 1,
                        name: "누가 코코볼 다 먹었어?",
                        meetingName: "우마우스",
                        dressUpLevel: "",
                        date: "2024.07.17",
                        time: "PM 2:00",
                        placeName: "가자하우스"
                    ),
                    UpcomingPromise(
                        promiseID: 3,
                        dDay: 1,
                        name: "누가 코코볼 다 먹었어?",
                        meetingName: "우마우스",
                        dressUpLevel: "",
                        date: "2024.07.17",
                        time: "PM 2:00",
                        placeName: "가자하우스"
                    ),
                    UpcomingPromise(
                        promiseID: 4,
                        dDay: 1,
                        name: "누가 코코볼 다 먹었어?",
                        meetingName: "우마우스",
                        dressUpLevel: "",
                        date: "2024.07.17",
                        time: "PM 2:00",
                        placeName: "가자하우스"
                    )
                ]
            ),
            error: nil
        )
        return mockData
    }
}
