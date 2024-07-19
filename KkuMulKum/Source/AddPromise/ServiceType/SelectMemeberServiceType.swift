//
//  SelectMemeberServiceType.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import Foundation

protocol SelectMemeberServiceType {
    func fetchMeetingMemberListExcludeLoginUser(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingMembersModel>?
}

extension PromiseService: SelectMemeberServiceType {
    func fetchMeetingMemberListExcludeLoginUser(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingMembersModel>? {
        return try await request(
            with: .fetchMeetingMemberExcludeMe(
                meetingID: meetingID
            )
        )
    }
}

final class MockSelectMemberService: SelectMemeberServiceType {
    func fetchMeetingMemberListExcludeLoginUser(
        with meetingID: Int
    ) async throws -> ResponseBodyDTO<MeetingMembersModel>? {
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
}
