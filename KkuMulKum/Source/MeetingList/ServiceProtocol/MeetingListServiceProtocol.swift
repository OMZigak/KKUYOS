//
//  MeetingListServiceProtocol.swift
//  KkuMulKum
//
//  Created by 예삐 on 8/26/24.
//

import Foundation

import Moya

protocol MeetingListServiceProtocol {
    func fetchLoginUser() async throws -> ResponseBodyDTO<LoginUserModel>?
    func fetchMeetingList() async throws -> ResponseBodyDTO<MeetingListModel>?
}
