//
//  PromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation

class PromiseViewModel {
    
    
    // MARK: Property

    /// 서버 통신을 위해 생성자로 주입받을 약속 ID
    let promiseID: Int
    
    private let service: PromiseServiceProtocol
    
    
    // MARK: Initialize

    init(
        promiseID: Int,
        service: PromiseServiceProtocol
    ) {
        self.service = service
        self.promiseID = promiseID
    }
}


// MARK: - Extension

extension PromiseViewModel {
    /// 약속 상세 정보 조회 API 구현 함수
    func fetchPromiseInfo() {
        Task {
            do {
                let result = try await service.fetchPromiseInfo(
                    with: promiseID
                )
                
                guard let success = result?.success,
                      success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 약속 참여자 목록 API 구현 함수
    func fetchPromiseParticipantList() {
        Task {
            do {
                let responseBody = try await service.fetchPromiseParticipantList(
                    with: promiseID
                )
                
                guard let success = responseBody?.success, 
                        success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 내 준비 현황 API 구현 함수
    func fetchMyReadyStatus() {
        Task {
            do {
                let responseBody = try await service.fetchMyReadyStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 준비 시작 업데이트 API 구현 함수
    func updatePreparationStatus() {
        Task {
            do {
                let responseBody = try await service.updatePreparationStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            }
            catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 이동 시작 업데이트 API 구현 함수
    func updateDepartureStatus() {
        Task {
            do {
                let responseBody = try await service.updateDepartureStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            }
            catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 도착 완료 업데이트 API 구현 함수
    func updateArrivalStatus(
        completion: @escaping () -> Void
    ) {
        Task {
            do {
                let responseBody = try await service.updateArrivalStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            }
            catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 약속 지각 상세 조회 API 구현 함수
    func fetchTardyInfo() {
        Task {
            do {
                let responseBody = try await service.fetchTardyInfo(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    /// 약속 완료 API 구현 함수
    func updatePromiseCompletion() {
        Task {
            do {
                let responseBody = try await service.updatePromiseCompletion(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    func deletePromise() {
        Task {
            do {
                let result = try await service.deletePromise(
                    promiseID: promiseID
                )
                
                guard let success = result?.success,
                      success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
    
    func exitPromise() {
        Task {
            do {
                let result = try await service.exitPromise(
                    promiseID: promiseID
                )
                
                guard let success = result?.success, 
                        success == true
                else {
                    return
                }
            } catch {
                print(
                    ">>>>> \(error.localizedDescription) : \(#function)"
                )
            }
        }
    }
}
