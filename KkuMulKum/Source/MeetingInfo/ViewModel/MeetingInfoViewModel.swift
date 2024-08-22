//
//  MeetingInfoViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/9/24.
//

import Foundation

import RxCocoa
import RxSwift

final class MeetingInfoViewModel {
    let meetingID: Int
    
    var meetingInvitationCode: String? { infoRelay.value?.invitationCode }
    var meetingPromises: [MeetingPromise] { meetingPromisesModelRelay.value?.promises ?? [] }
    
    private let service: MeetingInfoServiceType
    private let infoRelay = BehaviorRelay<MeetingInfoModel?>(value: nil)
    private let meetingMemberModelRelay = BehaviorRelay<MeetingMembersModel?>(value: nil)
    private let meetingPromisesModelRelay = BehaviorRelay<MeetingPromisesModel?>(value: nil)
    
    init(meetingID: Int, service: MeetingInfoServiceType) {
        self.meetingID = meetingID
        self.service = service
    }
}

extension MeetingInfoViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: PublishRelay<Void>
        let createPromiseButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let info: Driver<MeetingInfoModel?>
        let memberCount: Driver<Int>
        let members: Driver<[Member]>
        let promises: Driver<[MeetingPromise]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.fetchMeetingInfo()
                owner.fetchMeetingMembers()
                owner.fetchMeetingPromises()
            }
            .disposed(by: disposeBag)
        
        let info = infoRelay.asDriver(onErrorJustReturn: nil)
        
        let memberCount = meetingMemberModelRelay
            .compactMap { $0?.memberCount }
            .asDriver(onErrorJustReturn: 0)
        
        let members = meetingMemberModelRelay
            .map { model -> [Member] in
                let mockData = Member(memberID: 0, name: "", profileImageURL: "")
                
                guard let model else { return [mockData] }
                
                var newMembers = model.members
                newMembers.insert(mockData, at: 0)
                return newMembers
            }
            .asDriver(onErrorJustReturn: [])
        
        let promises = meetingPromisesModelRelay
            .map { model -> [MeetingPromise] in
                guard let model else { return [] }
                return model.promises
            }
            .compactMap { [weak self] promises in
                self?.reformattedDate(with: promises)
            }
            .asDriver(onErrorJustReturn: [])
            
        let output = Output(
            info: info,
            memberCount: memberCount,
            members: members,
            promises: promises
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
    
    func fetchMeetingPromises() {
        Task {
            do {
                let responseBody = try await service.fetchMeetingPromiseList(with: meetingID)
                meetingPromisesModelRelay.accept(responseBody?.data)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func reformattedDate(with promises: [MeetingPromise]) -> [MeetingPromise] {
        let inputDateFormat = "yyyy-MM-dd HH:mm:ss"
        let outputDateFormat = "yyyy.MM.dd a H:mm"
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = inputDateFormat
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputDateFormat
        outputDateFormatter.amSymbol = "AM"
        outputDateFormatter.pmSymbol = "PM"
        
        return promises.compactMap {
            guard let date = inputDateFormatter.date(from: $0.time) else { return nil }
            let reformattedDate = outputDateFormatter.string(from: date)
            
            return MeetingPromise(
                promiseID: $0.promiseID,
                name: $0.name,
                dDay: $0.dDay,
                time: reformattedDate,
                placeName: $0.placeName
            )
        }
    }
}
