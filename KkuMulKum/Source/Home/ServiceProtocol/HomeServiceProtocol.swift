//
//  HomeServiceProtocol.swift
//  KkuMulKum
//
//  Created by 예삐 on 8/23/24.
//

import Foundation

import Moya

protocol HomeServiceProtocol {
    func fetchLoginUser() async throws -> ResponseBodyDTO<LoginUserModel>?
    
    func fetchNearestPromise() async throws -> ResponseBodyDTO<NearestPromiseModel>?
    func fetchUpcomingPromise() async throws -> ResponseBodyDTO<UpcomingPromiseListModel>?
    func fetchMyReadyStatus(with promiseID: Int) async throws -> ResponseBodyDTO<MyReadyStatusModel>?
    
    func updatePreparationStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
    func updateDepartureStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
    func updateArrivalStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
}
