//
//  MeetingInfoService.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import Foundation

protocol MeetingInfoServiceType {
    func fetchMeetingInfo(with meetingID: Int) -> MeetingInfoModel?
    func fetchMeetingMemberList(with meetingID: Int) -> MeetingMembersModel?
    func fetchMeetingPromiseList(with meetingID: Int) -> MeetingPromisesModel?
}

final class MockMeetingInfoService: MeetingInfoServiceType {
    func fetchMeetingInfo(with meetingID: Int) -> MeetingInfoModel? {
        let mockData = MeetingInfoModel(
            meetingID: 1,
            name: "웅웅난진웅",
            createdAt: "2024.06.08",
            metCount: 3,
            invitationCode: "WD56CQ"
        )
        
        return mockData
    }
    
    func fetchMeetingMemberList(with meetingID: Int) -> MeetingMembersModel? {
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
        
        return mockData
    }
    
    func fetchMeetingPromiseList(with meetingID: Int) -> MeetingPromisesModel? {
        let mockData = MeetingPromisesModel(
            promises: [
                MeetingPromise(
                    id: 1,
                    name: "꾸물 리프레시 데이",
                    dDay: 0,
                    date: "2024.07.20",
                    time: "PM 2:00",
                    placeName: "DMC역"
                ),
                MeetingPromise(
                    id: 2,
                    name: "꾸물 잼얘 나이트", 
                    dDay: 10,
                    date: "2024.07.30",
                    time: "PM 6:00",
                    placeName: "홍대입구"
                ),
                MeetingPromise(
                    id: 3,
                    name: "친구 생일 파티",
                    dDay: 5,
                    date: "2024.07.25",
                    time: "PM 7:00",
                    placeName: "강남역"
                ),
                MeetingPromise(
                    id: 4,
                    name: "주말 산책",
                    dDay: 3,
                    date: "2024.07.23",
                    time: "AM 10:00", 
                    placeName: "서울숲"
                ),
                MeetingPromise(
                    id: 5,
                    name: "프로젝트 미팅",
                    dDay: 1,
                    date: "2024.07.21",
                    time: "AM 9:00",
                    placeName: "삼성역"
                ),
                MeetingPromise(
                    id: 6,
                    name: "독서 모임",
                    dDay: 7, 
                    date: "2024.07.27",
                    time: "PM 3:00",
                    placeName: "합정역"
                ),
                MeetingPromise(
                    id: 7,
                    name: "헬스클럽 모임",
                    dDay: 2,
                    date: "2024.07.22",
                    time: "AM 8:00",
                    placeName: "신촌역"
                ),
                MeetingPromise(
                    id: 8,
                    name: "영화 관람",
                    dDay: 4,
                    date: "2024.07.24",
                    time: "PM 8:00",
                    placeName: "잠실역"
                ),
                MeetingPromise(
                    id: 9,
                    name: "저녁 식사",
                    dDay: 6,
                    date: "2024.07.26",
                    time: "PM 7:30",
                    placeName: "이태원역"
                ),
                MeetingPromise(
                    id: 10,
                    name: "아침 조깅",
                    dDay: 14,
                    date: "2024.08.03",
                    time: "AM 6:00",
                    placeName: "한강공원"
                ),
                MeetingPromise(
                    id: 11,
                    name: "커피 브레이크",
                    dDay: 8,
                    date: "2024.07.28",
                    time: "PM 4:00",
                    placeName: "을지로입구"
                ),
                MeetingPromise(
                    id: 12,
                    name: "스터디 그룹",
                    dDay: 12,
                    date: "2024.08.01",
                    time: "PM 5:00",
                    placeName: "강남역"
                ),
                MeetingPromise(
                    id: 13,
                    name: "뮤직 페스티벌",
                    dDay: 9,
                    date: "2024.07.29",
                    time: "PM 2:00",
                    placeName: "난지공원"
                ),
                MeetingPromise(
                    id: 14,
                    name: "낚시 여행",
                    dDay: 11,
                    date: "2024.07.31",
                    time: "AM 5:00",
                    placeName: "속초항"
                ),
                MeetingPromise(
                    id: 15,
                    name: "가족 모임",
                    dDay: 13,
                    date: "2024.08.02",
                    time: "PM 1:00",
                    placeName: "광화문역"
                )
            ]
        )
        
        return mockData
    }
}
