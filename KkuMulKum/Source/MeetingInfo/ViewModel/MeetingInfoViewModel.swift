//
//  MeetingInfoViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import Foundation

import RxCocoa
import RxSwift
import Then

final class MeetingInfoViewModel {
    let meetingID: Int
    
    var meetingName: String { infoRelay.value?.name ?? "" }
    var meetingInvitationCode: String? { infoRelay.value?.invitationCode }
    
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        $0.amSymbol = "AM"
        $0.pmSymbol = "PM"
    }
    private let service: MeetingInfoServiceProtocol
    private let infoRelay = BehaviorRelay<MeetingInfoModel?>(value: nil)
    private let meetingMemberModelRelay = BehaviorRelay<MeetingMembersModel?>(value: nil)
    
    init(meetingID: Int, service: MeetingInfoServiceProtocol) {
        self.meetingID = meetingID
        self.service = service
    }
}

extension MeetingInfoViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: PublishRelay<Void>
        let createPromiseButtonDidTap: Observable<Void>
        let actionButtonDidTapRelay: PublishRelay<Void>
        let selectedSegmentedIndex: Observable<Int>
        let promiseCellDidSelect: Observable<Int>
    }
    
    struct Output {
        let info: Driver<MeetingInfoModel?>
        let memberCount: Driver<Int>
        let members: Driver<[Member]>
        let promises: Driver<[MeetingInfoPromiseModel]>
        let isExitMeetingSucceed: Driver<Bool>
        let navigateToPromiseInfo: Driver<Int>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.fetchMeetingInfo()
                owner.fetchMeetingMembers()
            }
            .disposed(by: disposeBag)
        
        let info = infoRelay
            .map { [weak self] info -> MeetingInfoModel? in
                guard let self,
                      let info 
                else {
                    print(">>> 모델이 존재하지 않습니다. : \(#function) : \(Self.self)")
                    return nil
                }
                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                guard let date = dateFormatter.date(from: info.createdAt) else {
                    print("서버의 date가 형식에 맞지 않습니다.")
                    return nil
                }
                
                dateFormatter.dateFormat = "yyyy.MM.dd"
                let dateString = dateFormatter.string(from: date)
                
                return MeetingInfoModel(
                    meetingID: info.meetingID,
                    name: info.name,
                    createdAt: dateString,
                    metCount: info.metCount,
                    invitationCode: info.invitationCode
                )
            }
            .asDriver(onErrorJustReturn: nil)
        
        let memberCount = meetingMemberModelRelay
            .compactMap { $0?.memberCount }
            .asDriver(onErrorJustReturn: 0)
        
        let members = meetingMemberModelRelay
            .map { model -> [Member] in
                let mockData = Member(memberID: 0, name: "", profileImageURL: "")
                
                guard let model else {
                    return [mockData]
                }
                
                var newMembers = model.members
                newMembers.insert(mockData, at: 0)
                return newMembers
            }
            .asDriver(onErrorJustReturn: [])
        
        let promises = Observable.merge(
            input.viewWillAppear.withLatestFrom(input.selectedSegmentedIndex),
            input.selectedSegmentedIndex
        )
            .startWith(0)
            .flatMapLatest { [weak self] index -> Observable<[MeetingInfoPromiseModel]> in
                guard let self else {
                    return .just([])
                }
                
                if index == 0 {
                    return service.fetchParticipatedPromiseList(with: self.meetingID, isParticipant: true)
                        .map { response in
                            self.convertToMeetingInfoPromiseModels(from: response.data?.promises ?? [])
                        }
                        .asObservable()
                        .catchAndReturn([])
                } else {
                    return service.fetchMeetingPromiseList(with: self.meetingID)
                        .map { response in
                            self.convertToMeetingInfoPromiseModels(from: response.data?.promises ?? [])
                        }
                        .asObservable()
                        .catchAndReturn([])
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let navigateToPromiseInfo = input.promiseCellDidSelect
            .withLatestFrom(promises) { index, promises in
                return promises[index].promiseID
            }
            .asDriver(onErrorJustReturn: -1)
        
        let isExitMeetingSucceed = input.actionButtonDidTapRelay
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let self else {
                    return Driver.just(false)
                }
                
                return service.exitMeeting(with: meetingID)
                    .map { $0.success }
                    .asDriver(onErrorJustReturn: false)
            }
            .asDriver(onErrorJustReturn: false)
        
        let output = Output(
            info: info,
            memberCount: memberCount,
            members: members,
            promises: promises,
            isExitMeetingSucceed: isExitMeetingSucceed,
            navigateToPromiseInfo: navigateToPromiseInfo
        )
        
        return output
    }
}

private extension MeetingInfoViewModel {
    func fetchMeetingInfo() {
        Task {
            do {
                let responseBody = try await service.fetchMeetingInfo(with: meetingID)
                infoRelay.accept(responseBody?.data)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func fetchMeetingMembers() {
        Task {
            do {
                let responseBody = try await service.fetchMeetingMemberList(with: meetingID)
                meetingMemberModelRelay.accept(responseBody?.data)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func convertToMeetingInfoPromiseModels(from promises: [MeetingPromise]) -> [MeetingInfoPromiseModel] {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let outputDateFormatter = DateFormatter().then {
            $0.locale = Locale(identifier: "ko_KR")
            $0.timeZone = TimeZone(identifier: "Asia/Seoul")
            $0.dateFormat = "yyyy.MM.dd a h:mm"
            $0.amSymbol = "AM"
            $0.pmSymbol = "PM"
        }
        
        return promises.compactMap { promise in
            guard let date = dateFormatter.date(from: promise.time) else { return nil }
            let formattedDate = outputDateFormatter.string(from: date)
            let (dateString, timeString) = splitDateAndTime(from: formattedDate)
            let (dDayString, state) = configure(dDay: promise.dDay)
            
            return MeetingInfoPromiseModel(
                state: state,
                promiseID: promise.promiseID,
                name: promise.name,
                dDayText: dDayString,
                dateText: dateString,
                timeText: timeString,
                placeName: promise.placeName
            )
        }
    }
    
    func splitDateAndTime(from formattedDate: String) -> (String, String) {
        let components = formattedDate.split(separator: " ").map { "\($0)" }
        guard components.count >= 3 else { return ("", "") }
        let dateString = components[0]
        let timeString = "\(components[1]) \(components[2])"
        return (dateString, timeString)
    }
    
    func configure(dDay: Int) -> (dDayText: String, state: MeetingPromiseCell.State) {
        if 0 < dDay {
            return ("+\(dDay)", .past)
        } else if 0 == dDay {
            return ("-DAY", .today)
        } else {
            return ("\(dDay)", .future)
        }
    }
}
