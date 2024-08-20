//
//  MeetingInfoService.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import Foundation

protocol MeetingInfoServiceType {
    func fetchMeetingInfo(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingInfoModel>?
    func fetchMeetingMemberList(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingMembersModel>?
    func fetchMeetingPromiseList(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingPromisesModel>?
}

extension MeetingService: MeetingInfoServiceType {
    func fetchMeetingInfo(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingInfoModel>? {
        return try await request(with: .fetchMeetingInfo(meetingID: meetingID))
    }
    
    func fetchMeetingMemberList(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingMembersModel>? {
        return try await request(with: .fetchMeetingMember(meetingID: meetingID))
    }
    
    func fetchMeetingPromiseList(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingPromisesModel>? {
        return try await request(with: .fetchMeetingPromiseList(meetingID: meetingID))
    }    
}

final class MockMeetingInfoService: MeetingInfoServiceType {
    func fetchMeetingInfo(with meetingID: Int) -> ResponseBodyDTO<MeetingInfoModel>? {
        let mockData = MeetingInfoModel(
            meetingID: 1,
            name: "웅웅난진웅",
            createdAt: "2024.06.08",
            metCount: 3,
            invitationCode: "WD56CQ"
        )
        
        return ResponseBodyDTO(success: true, data: mockData, error: nil)
    }
    
    func fetchMeetingMemberList(with meetingID: Int) -> ResponseBodyDTO<MeetingMembersModel>? {
        let mockData = MeetingMembersModel(
            memberCount: 14,
            members: [
                Member(
                    memberID: 1,
                    name: "김진웅",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 2,
                    name: "김수연",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 3,
                    name: "이지훈",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 4,
                    name: "이유진",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 5,
                    name: "이승현",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 6,
                    name: "허준혁",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 7,
                    name: "배차은우",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 8,
                    name: "김윤서",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 9,
                    name: "정혜진",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 10,
                    name: "주효은",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 11,
                    name: "박상준",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 12,
                    name: "김채원",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 13,
                    name: "류희재",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    memberID: 14,
                    name: "김민지",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                )
            ]
        )
        
        return ResponseBodyDTO(success: true, data: mockData, error: nil)
    }
    
    func fetchMeetingPromiseList(with meetingID: Int) -> ResponseBodyDTO<MeetingPromisesModel>? {
        let mockData = MeetingPromisesModel(
            promises: [
                MeetingPromise(
                    promiseID: 1,
                    name: "꾸물 리프레시 데이",
                    dDay: 0,
                    time: "PM 2:00",
                    placeName: "DMC역"
                ),
                MeetingPromise(
                    promiseID: 2,
                    name: "꾸물 잼얘 나이트", 
                    dDay: 10,
                    time: "PM 6:00",
                    placeName: "홍대입구"
                ),
                MeetingPromise(
                    promiseID: 3,
                    name: "친구 생일 파티",
                    dDay: 5,
                    time: "PM 7:00",
                    placeName: "강남역"
                ),
                MeetingPromise(
                    promiseID: 4,
                    name: "주말 산책",
                    dDay: 3,
                    time: "AM 10:00", 
                    placeName: "서울숲"
                ),
                MeetingPromise(
                    promiseID: 5,
                    name: "프로젝트 미팅",
                    dDay: 1,
                    time: "AM 9:00",
                    placeName: "삼성역"
                ),
                MeetingPromise(
                    promiseID: 6,
                    name: "독서 모임",
                    dDay: 7,
                    time: "PM 3:00",
                    placeName: "합정역"
                ),
                MeetingPromise(
                    promiseID: 7,
                    name: "헬스클럽 모임",
                    dDay: 2,
                    time: "AM 8:00",
                    placeName: "신촌역"
                ),
                MeetingPromise(
                    promiseID: 8,
                    name: "영화 관람",
                    dDay: 4,
                    time: "PM 8:00",
                    placeName: "잠실역"
                ),
                MeetingPromise(
                    promiseID: 9,
                    name: "저녁 식사",
                    dDay: 6,
                    time: "PM 7:30",
                    placeName: "이태원역"
                ),
                MeetingPromise(
                    promiseID: 10,
                    name: "아침 조깅",
                    dDay: 14,
                    time: "AM 6:00",
                    placeName: "한강공원"
                ),
                MeetingPromise(
                    promiseID: 11,
                    name: "커피 브레이크",
                    dDay: 8,
                    time: "PM 4:00",
                    placeName: "을지로입구"
                ),
                MeetingPromise(
                    promiseID: 12,
                    name: "스터디 그룹",
                    dDay: 12,
                    time: "PM 5:00",
                    placeName: "강남역"
                ),
                MeetingPromise(
                    promiseID: 13,
                    name: "뮤직 페스티벌",
                    dDay: 9,
                    time: "PM 2:00",
                    placeName: "난지공원"
                ),
                MeetingPromise(
                    promiseID: 14,
                    name: "낚시 여행",
                    dDay: 11,
                    time: "AM 5:00",
                    placeName: "속초항"
                ),
                MeetingPromise(
                    promiseID: 15,
                    name: "가족 모임",
                    dDay: 13,
                    time: "PM 1:00",
                    placeName: "광화문역"
                )
            ]
        )
        
        return ResponseBodyDTO(success: true, data: mockData, error: nil)
    }
}
