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
    
    var loginUser = ObservablePattern<LoginUserModel?>(nil)
    var nearestPromise = ObservablePattern<NearestPromiseModel?>(nil)
    var upcomingPromiseList = ObservablePattern<UpcomingPromiseListModel?>(nil)
    
    var levelName = ObservablePattern<String>("")
    var levelCaption = ObservablePattern<String>("")
    
    private let service: HomeServiceType
    
    init(service: HomeServiceType) {
        self.service = service
    }
    
    var homePrepareTime: String = ""
    var homeMoveTime: String = ""
    var homeArriveTime: String = ""
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "a hh:mm"
        $0.amSymbol = "AM"
        $0.pmSymbol = "PM"
    }
    
    func updateState(newState: ReadyState) {
        currentState.value = newState
        let currentTimeString = dateFormatter.string(from: Date())
        switch newState {
        case .prepare:
            homePrepareTime = currentTimeString
        case .move:
            homeMoveTime = currentTimeString
        case .arrive:
            homeArriveTime = currentTimeString
        case .none:
            break
        }
    }
    
    ///서버에서 보내주는 level Int 값에 따른 levelName
    func getLevelName(level: Int) -> String {
        switch level {
            case 1: return "빼꼼 꾸물이"
            case 2: return "밍기적 꾸물이"
            case 3: return "기적 꾸물이"
            case 4: return "꾸물꿈"
            default: return ""
        }
    }
    
    ///서버에서 보내주는 level Int 값에 따른 levelCaption
    func getLevelCaption(level: Int) -> String {
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
    
    func requestLoginUser() {
        loginUser.value = service.fetchLoginUser()
        levelName.value = getLevelName(level: loginUser.value?.level ?? 1)
        levelCaption.value = getLevelCaption(level: loginUser.value?.level ?? 1)
    }
    
    func requestNearestPromise() {
        nearestPromise.value = service.fetchNearestPromise()
    }
    
    func requestUpcomingPromise() {
        upcomingPromiseList.value = service.fetchUpcomingPromise()
    }
}
