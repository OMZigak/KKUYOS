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
    var meetingInvitationCode: String? { infoRelay.value?.invitationCode }
    
    private let service: MeetingInfoServiceType
    private let infoRelay = BehaviorRelay<MeetingInfoModel?>(value: nil)
    private let meetingMemberModelRelay = BehaviorRelay<MeetingMembersModel?>(value: nil)
    
    init(service: MeetingInfoServiceType) {
        self.service = service
    }
}

extension MeetingInfoViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: PublishRelay<Void>
    }
    
    struct Output {
        let info: Driver<MeetingInfoModel?>
        let memberCount: Driver<Int>
        let members: Driver<[Member]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppear
            .map { [weak self] _ in
                return self?.service.fetchMeetingInfo(with: 1)
            }
            .bind(to: infoRelay)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .map { [weak self] _ in
                return self?.service.fetchMeetingMemberList(with: 1)
            }
            .bind(to: meetingMemberModelRelay)
            .disposed(by: disposeBag)
        
        let info = infoRelay.asDriver(onErrorJustReturn: nil)
        
        let memberCount = meetingMemberModelRelay
            .compactMap { $0?.memberCount }
            .asDriver(onErrorJustReturn: 0)
        
        let members = meetingMemberModelRelay
            .compactMap { $0?.members }
            .map { members -> [Member] in
                let mockData = Member(id: 0, name: "", profileImageURL: "")
                var newMembers = members
                newMembers.insert(mockData, at: 0)
                return newMembers
            }
            .asDriver(onErrorJustReturn: [])
        
        let output = Output(
            info: info,
            memberCount: memberCount,
            members: members
        )
        
        return output
    }
}
