//
//  MeetingInfoService.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import Foundation

import RxSwift

protocol MeetingInfoServiceProtocol {
    func fetchMeetingInfo(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingInfoModel>?
    func fetchMeetingMemberList(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingMembersModel>?
    func fetchMeetingPromiseList(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingPromisesModel>?
    func exitMeeting(with meetingID: Int) -> Single<ResponseBodyDTO<EmptyModel>>
}
