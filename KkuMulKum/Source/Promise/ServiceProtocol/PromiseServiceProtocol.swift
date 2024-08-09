//
//  PromiseServiceProtocol.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/19/24.
//

import Foundation

protocol PromiseServiceProtocol {
    /// 약속 정보
    func fetchPromiseInfo(with promiseId: Int) async throws -> ResponseBodyDTO<PromiseInfoModel>?
    
    /// 준비 현황
    func fetchMyReadyStatus(with promiseID: Int) async throws -> ResponseBodyDTO<MyReadyStatusModel>?
    func fetchPromiseParticipantList(with promiseID: Int) async throws -> ResponseBodyDTO<PromiseParticipantListModel>?
    func updatePreparationStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
    func updateDepartureStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
    func updateArrivalStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
    
    /// 지각 꾸물이
    func fetchTardyInfo(with promiseID: Int) async throws -> ResponseBodyDTO<TardyInfoModel>?
    func updatePromiseCompletion(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
}

