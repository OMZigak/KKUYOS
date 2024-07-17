//
//  SelectMemberViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SelectMemberViewModel {
    let meetingID: Int
    let name: String
    let place: Place
    let promiseDateString: String
    
    var members: [Member] { memberListRelay.value }
    var selectedMembers: [Member] { selectedMemberListRelay.value }
    
    private let service: SelectMemeberServiceType
    private let memberListRelay = BehaviorRelay<[Member]>(value: [])
    private let selectedMemberListRelay = BehaviorRelay<[Member]>(value: [])
    
    init(
        meetingID: Int,
        name: String,
        place: Place,
        promiseDateString: String,
        service: SelectMemeberServiceType
    ) {
        self.meetingID = meetingID
        self.name = name
        self.place = place
        self.promiseDateString = promiseDateString
        self.service = service
    }
}

extension SelectMemberViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Observable<Void>
        let memberSelected: Observable<Member>
        let memberDeselected: Observable<Member>
    }
    
    struct Output {
        let memberList: Driver<[Member]>
        let isEnabledConfirmButton: Driver<Bool>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoad
            .map { [weak self] _ -> [Member] in
                guard let self else { return [] }
                let responseBodyDTO = service.fetchMeetingMemberList(with: meetingID)
                guard let data = responseBodyDTO.data else { return [] }
                return data.members
            }
            .bind(to: memberListRelay)
            .disposed(by: disposeBag)
        
        input.memberSelected
            .subscribe(with: self) { owner, member in
                var selectedMembers = owner.selectedMemberListRelay.value
                guard !selectedMembers.contains(where: { $0.id == member.id }) else { return }
                selectedMembers.append(member)
                owner.selectedMemberListRelay.accept(selectedMembers)
            }
            .disposed(by: disposeBag)
    
        input.memberDeselected
            .subscribe(with: self) { owner, member in
                var selectedMembers = owner.selectedMemberListRelay.value
                guard selectedMembers.contains(where: { $0.id == member.id }) else { return }
                selectedMembers.removeAll { $0.id == member.id }
                owner.selectedMemberListRelay.accept(selectedMembers)
            }
            .disposed(by: disposeBag)
        
        let isEnabledConfirmButton = selectedMemberListRelay
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let output = Output(
            memberList: memberListRelay.asDriver(onErrorJustReturn: []),
            isEnabledConfirmButton: isEnabledConfirmButton
        )
        
        return output
    }
}
