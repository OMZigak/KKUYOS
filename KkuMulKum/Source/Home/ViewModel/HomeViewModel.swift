//
//  HomeViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/11/24.
//

import UIKit

import Then

enum ReadyState {
    case none
    case prepare
    case move
    case arrive
}

final class HomeViewModel {
    var currentState = ObservablePattern<ReadyState>(.none)
    
    var loginUser = ObservablePattern<ResponseBodyDTO<LoginUserModel>?>(nil)
    var nearestPromise = ObservablePattern<ResponseBodyDTO<NearestPromiseModel>?>(nil)
    var upcomingPromiseList = ObservablePattern<ResponseBodyDTO<UpcomingPromiseListModel>?>(nil)
    var myReadyStatus = ObservablePattern<ResponseBodyDTO<MyReadyStatusModel>?>(nil)
    
    var levelName = ObservablePattern<String>("")
    var levelCaption = ObservablePattern<String>("")
    
    var isPreapreSucceedToSave = ObservablePattern<Bool>(false)
    var isMoveSucceedToSave = ObservablePattern<Bool>(false)
    var isArriveSucceedToSave = ObservablePattern<Bool>(false)
    
    private let service: HomeServiceType
    
    init(service: HomeServiceType) {
        self.service = service
    }
    
//    var homePrepareTime: String = ""
//    var homeMoveTime: String = ""
//    var homeArriveTime: String = ""
    
//    private let dateFormatter = DateFormatter().then {
//        $0.dateFormat = "a hh:mm"
//        $0.amSymbol = "AM"
//        $0.pmSymbol = "PM"
//    }
    
//    private func updateState(newState: ReadyState) {
//        currentState.value = newState
//        let currentTimeString = dateFormatter.string(from: Date())
//        switch newState {
//        case .prepare:
//            homePrepareTime = currentTimeString
//        case .move:
//            homeMoveTime = currentTimeString
//        case .arrive:
//            homeArriveTime = currentTimeString
//        case .none:
//            break
//        }
//    }
    
    ///서버에서 보내주는 level Int 값에 따른 levelName
    private func getLevelName(level: Int) -> String {
        switch level {
            case 1: return "빼꼼 꾸물이"
            case 2: return "밍기적 꾸물이"
            case 3: return "기적 꾸물이"
            case 4: return "꾸물꿈"
            default: return ""
        }
    }
    
    ///서버에서 보내주는 level Int 값에 따른 levelCaption
    private func getLevelCaption(level: Int) -> String {
        switch level {
        case 1:
            return "꾸물꿈에 오신 것을 환영해요!\n정시 도착으로 캐릭터를 성장시켜 보세요."
        case 2:
            return "정시 도착의 꿈에 한 발짝 가까워졌어요!\n5번 정시 도착 시, ‘기적 꾸물이’가 될 수 있어요."
        case 3:
            return "잘 하고 있어요!\n10번 정시 도착 시, ‘꾸물꿈’ 레벨로 성장할 수 있어요."
        case 4:
            return "드디어 ‘꾸물꿈’ 레벨을 달성했네요.\n지각 꾸물이에서 탈출한 것을 축하해요!"
        default:
            return ""
        }
    }
    
    private func judgeReadyStatus() {
        let data = myReadyStatus.value?.data
        if data?.preparationStartAt == nil && data?.departureAt == nil && data?.arrivalAt == nil {
            currentState.value = .none
        } else if data?.preparationStartAt != nil && data?.departureAt == nil && data?.arrivalAt == nil {
            currentState.value = .prepare
        } else if data?.departureAt != nil && data?.arrivalAt == nil {
            currentState.value = .move
        } else if data?.arrivalAt != nil {
            currentState.value = .arrive
        }
    }
    
    func requestMyReadyStatus() {
        Task  {
            do {
                print(currentState.value)
                myReadyStatus.value = try await service.fetchMyReadyStatus(
                    with: nearestPromise.value?.data?.promiseID ?? 1
                )
                judgeReadyStatus()
                print(currentState.value)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func updatePrepareStatus() {
        Task {
            do {
                guard let responseBody = try await service.updatePreparationStatus(
                    with: nearestPromise.value?.data?.promiseID ?? 1
                ) 
                else {
                    isPreapreSucceedToSave.value = false
                    return
                }
                isPreapreSucceedToSave.value = responseBody.success
                currentState.value = .prepare
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func updateMoveStatus() {
        Task {
            do {
                guard let responseBody = try await service.updateDepartureStatus(
                    with: nearestPromise.value?.data?.promiseID ?? 1
                ) 
                else {
                    isMoveSucceedToSave.value = false
                    return
                }
                isMoveSucceedToSave.value = responseBody.success
                currentState.value = .move
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func updateArriveStatus() {
        Task {
            do {
                guard let responseBody = try await service.updateArrivalStatus(
                    with: nearestPromise.value?.data?.promiseID ?? 1
                )
                else {
                    isArriveSucceedToSave.value = false
                    return
                }
                isArriveSucceedToSave.value = responseBody.success
                currentState.value = .arrive
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func requestLoginUser() {
        Task {
            do {
                loginUser.value = try await service.fetchLoginUser()
                levelName.value = getLevelName(level: loginUser.value?.data?.level ?? 1)
                levelCaption.value = getLevelCaption(level: loginUser.value?.data?.level ?? 1)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func requestNearestPromise() {
        Task  {
            do {
                nearestPromise.value = try await service.fetchNearestPromise()
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func requestUpcomingPromise() {
        Task {
            do {
                upcomingPromiseList.value = try await service.fetchUpcomingPromise()
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
