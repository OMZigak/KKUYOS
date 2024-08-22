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
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchMeetingMembers()
            }
            .disposed(by: disposeBag)
        
        input.memberSelected
            .subscribe(with: self) { owner, member in
                var selectedMembers = owner.selectedMemberListRelay.value
                guard !selectedMembers.contains(where: { $0.memberID == member.memberID }) else { return }
                selectedMembers.append(member)
                owner.selectedMemberListRelay.accept(selectedMembers)
            }
            .disposed(by: disposeBag)
        
        input.memberDeselected
            .subscribe(with: self) { owner, member in
                var selectedMembers = owner.selectedMemberListRelay.value
                guard selectedMembers.contains(where: { $0.memberID == member.memberID }) else { return }
                selectedMembers.removeAll { $0.memberID == member.memberID }
                owner.selectedMemberListRelay.accept(selectedMembers)
            }
            .disposed(by: disposeBag)
        
        let output = Output(
            memberList: memberListRelay.asDriver(onErrorJustReturn: [])
        )
        
        return output
    }
}

private extension SelectMemberViewModel {
    func fetchMeetingMembers() {
        Task {
            do {
                guard let responseBody = try await service.fetchMeetingMemberListExcludeLoginUser(with: meetingID),
                      responseBody.success
                else {
                    memberListRelay.accept([])
                    return
                }
                memberListRelay.accept(responseBody.data?.members ?? [])
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
