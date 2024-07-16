//
//  SelectMemeberServiceType.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import Foundation

protocol SelectMemeberServiceType {
    func fetchMeetingMemberList(with meetingID: Int) -> MeetingMembersModel
}

final class MockSelectMemberService: SelectMemeberServiceType {
    func fetchMeetingMemberList(with meetingID: Int) -> MeetingMembersModel {
        let mockData = MeetingMembersModel(
            memberCount: 14,
            members: [
                Member(
                    id: 1,
                    name: "김진웅",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 2,
                    name: "김수연",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 3,
                    name: "이지훈",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 4,
                    name: "이유진",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 5,
                    name: "이승현",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 6,
                    name: "허준혁",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 7,
                    name: "배차은우",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 8,
                    name: "김윤서",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 9,
                    name: "정혜진",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 10,
                    name: "주효은",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 11,
                    name: "박상준",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 12,
                    name: "김채원",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 13,
                    name: "류희재",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                ),
                Member(
                    id: 14,
                    name: "김민지",
                    profileImageURL: "https://reqres.in/img/faces/\(Int.random(in: 1...10))-image.jpg"
                )
            ]
        )
        
        return mockData
    }
}
