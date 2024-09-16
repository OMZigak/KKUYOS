//
//  PromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation

class PromiseViewModel {
    
    
    // MARK: Property

    let promiseID: Int
    let currentPageIndex = ObservablePattern<Int>(0)
    let promiseInfo = ObservablePattern<PromiseInfoModel?>(nil)
    let isPastDue = ObservablePattern<Bool?>(nil)
    let penalty = ObservablePattern<String?>(nil)
    let dDay = ObservablePattern<Int?>(nil)
    let participantList = ObservablePattern<[Participant]>([])
    let tardyList = ObservablePattern<[Comer]>([])
    
    var pageControlDirection = false
    
    private let service: PromiseServiceProtocol
    
    
    // MARK: Initialize

    init(promiseID: Int, service: PromiseServiceProtocol) {
        self.service = service
        self.promiseID = promiseID
    }
}


// MARK: - Extension

private extension PromiseViewModel {
    func calculateDday() {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let dateWithTime = dateFormatter.date(from: promiseInfo.value?.time ?? "") else { return }
        
        let dateOnly = calendar.startOfDay(for: dateWithTime)
        let today = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: today, to: dateOnly)
        
        dDay.value = components.day
    }
}

extension PromiseViewModel {
    func isEditButtonHidden() -> Bool {
        guard let isParticipant = promiseInfo.value?.isParticipant,
              let isPastDue = isPastDue.value 
        else {
            return false
        }
        
        return !(isParticipant && !isPastDue)
    }
    
    /// 약속 상세 정보 조회 API 구현 함수
    func fetchPromiseInfo() {
        Task {
            do {
                let result = try await service.fetchPromiseInfo(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
                
                promiseInfo.value = result?.data
                
                calculateDday()
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 약속 참여자 목록 API 구현 함수
    func fetchPromiseParticipantList() {
        Task {
            do {
                let result = try await service.fetchPromiseParticipantList(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
                
                guard let data = result?.data else {
                    print(">>>>> \("데이터 없음") : \(#function)")
                    return
                }
                
                participantList.value = data.participants
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 내 준비 현황 API 구현 함수
    func fetchMyReadyStatus() {
        Task {
            do {
                let result = try await service.fetchMyReadyStatus(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 준비 시작 업데이트 API 구현 함수
    func updatePreparationStatus() {
        Task {
            do {
                let result = try await service.updatePreparationStatus(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            }
            catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 이동 시작 업데이트 API 구현 함수
    func updateDepartureStatus() {
        Task {
            do {
                let result = try await service.updateDepartureStatus(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            }
            catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 도착 완료 업데이트 API 구현 함수
    func updateArrivalStatus() {
        Task {
            do {
                let result = try await service.updateArrivalStatus(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            }
            catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 약속 지각 상세 조회 API 구현 함수
    func fetchTardyInfo() {
        Task {
            do {
                let result = try await service.fetchTardyInfo(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
                
                guard let data = result?.data else {
                    print(">>>>> \("데이터 없음") : \(#function)")
                    return
                }
                
                penalty.value = data.penalty
                isPastDue.value = data.isPastDue
                tardyList.value = data.lateComers
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 약속 완료 API 구현 함수
    func updatePromiseCompletion() {
        Task {
            do {
                let result = try await service.updatePromiseCompletion(with: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 약속 삭제 API 구현 함수
    func deletePromise() {
        Task {
            do {
                let result = try await service.deletePromise(promiseID: promiseID)
                
                guard let success = result?.success,
                      success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 약속 나가기 API 구현 함수
    func exitPromise() {
        Task {
            do {
                let result = try await service.exitPromise(promiseID: promiseID)
                
                guard let success = result?.success, 
                        success == true
                else {
                    print(">>>>> \(String(describing: result)) : \(#function)")
                    return
                }
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
