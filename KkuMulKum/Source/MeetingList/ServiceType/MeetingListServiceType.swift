//
//  MeetingListServiceType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

protocol MeetingListServiceType {
    func fetchMeetingList() async throws -> ResponseBodyDTO<MeetingListModel>?
}

extension MeetingService: MeetingListServiceType {
    func fetchMeetingList() async throws -> ResponseBodyDTO<MeetingListModel>? {
        return try await request(with: .fetchMeetingList)
    }
}

final class MockMeetingListService: MeetingListServiceType {
    func fetchMeetingList() async throws -> ResponseBodyDTO<MeetingListModel>? {
        let mockData = ResponseBodyDTO<MeetingListModel>(
            success: true,
            data: MeetingListModel(
                count: 6,
                meetings: [
                    Meeting(meetingID: 1, name: "꾸물이들", memberCount: 14),
                    Meeting(meetingID: 2, name: "아요레디", memberCount: 28),
                    Meeting(meetingID: 3, name: "안드가자", memberCount: 26),
                    Meeting(meetingID: 4, name: "난이서버", memberCount: 30),
                    Meeting(meetingID: 5, name: "캔디팟", memberCount: 24),
                    Meeting(meetingID: 6, name: "열기팟", memberCount: 24)
                ]
            ),
            error: nil
        )
        return mockData
    }
}
