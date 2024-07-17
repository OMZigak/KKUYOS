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
        let isPossbleToCreatePromise: Driver<Bool>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let meetingID = self.meetingID
        
        input.viewWillAppear
            .map { [weak self] _ in
                self?.service.fetchMeetingInfo(with: meetingID)
            }
            .bind(to: infoRelay)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .map { [weak self] _ in
                self?.service.fetchMeetingMemberList(with: meetingID)
            }
            .bind(to: meetingMemberModelRelay)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .map { [weak self] _ in
                self?.service.fetchMeetingPromiseList(with: meetingID)
            }
            .bind(to: meetingPromisesModelRelay)
            .disposed(by: disposeBag)
        
        let info = infoRelay.asDriver(onErrorJustReturn: nil)
        
        let memberCount = meetingMemberModelRelay
            .compactMap { $0?.memberCount }
            .asDriver(onErrorJustReturn: 0)
        
        let members = meetingMemberModelRelay
            .compactMap { $0?.members }
            .map { members -> [Member] in
                let mockData = Member(memberID: 0, name: "", profileImageURL: "")
                var newMembers = members
                newMembers.insert(mockData, at: 0)
                return newMembers
            }
            .asDriver(onErrorJustReturn: [])
        
        let promises = meetingPromisesModelRelay
            .compactMap { $0?.promises }
            .map { $0.sorted { $0.dDay < $1.dDay }}
            .asDriver(onErrorJustReturn: [])
        
        let isPossibleToCreatePromise = input.createPromiseButtonDidTap
            .map { [weak self] _ in
                guard let count = self?.meetingMemberModelRelay.value?.memberCount,
                      count != 0
                else {
                    return false
                }
                return true
            }
            .asDriver(onErrorJustReturn: false)
            
        
        let output = Output(
            info: info,
            memberCount: memberCount,
            members: members,
            promises: promises,
            isPossbleToCreatePromise: isPossibleToCreatePromise
        )
        
        return output
    }
}
