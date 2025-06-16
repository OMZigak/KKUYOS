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
    private let builder: AddPromiseRequestModel.Builder
    private let service: SelectMemeberServiceType
    private let memberListRelay = BehaviorRelay<[Member]>(value: [])
    
    init(
        builder: AddPromiseRequestModel.Builder,
        service: SelectMemeberServiceType
    ) {
        self.builder = builder
        self.service = service
    }
}

extension SelectMemberViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Observable<Void>
        let memberSelected: Observable<Int>
        let memberDeselected: Observable<Int>
        let confirmButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let memberList: Driver<[Member]>
        let navigateToSelectPenalty: Observable<AddPromiseRequestModel.Builder>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let selectedMemberListRelay = BehaviorRelay<[Member]>(value: [])
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.fetchMeetingMembers()
            }
            .disposed(by: disposeBag)
        
        input.memberSelected
            .subscribe(with: self) { owner, selectedItem in
                guard selectedItem < owner.memberListRelay.value.count else { return }
                let selectedMember = owner.memberListRelay.value[selectedItem]
                
                var selectedMembers = selectedMemberListRelay.value
                guard !selectedMembers.contains(where: { $0.memberID == selectedMember.memberID }) else { return }
                selectedMembers.append(selectedMember)
                selectedMemberListRelay.accept(selectedMembers)
            }
            .disposed(by: disposeBag)
        
        input.memberDeselected
            .subscribe(with: self) { owner, deselectedItem in
                guard deselectedItem < owner.memberListRelay.value.count else { return }
                let deselectedMember = owner.memberListRelay.value[deselectedItem]
                
                var selectedMembers = selectedMemberListRelay.value
                guard selectedMembers.contains(where: { $0.memberID == deselectedMember.memberID }) else { return }
                selectedMembers.removeAll { $0.memberID == deselectedMember.memberID }
                selectedMemberListRelay.accept(selectedMembers)
            }
            .disposed(by: disposeBag)
        
        let navigateToSelectPenalty = input.confirmButtonDidTap
            .withLatestFrom(selectedMemberListRelay)
            .compactMap { [weak self] selectedMembers in
                return self?.builder
                    .setParticipants(selectedMembers.map { $0.memberID })
            }
        
        let output = Output(
            memberList: memberListRelay.asDriver(onErrorJustReturn: []),
            navigateToSelectPenalty: navigateToSelectPenalty
        )
        
        return output
    }
}

private extension SelectMemberViewModel {
    func fetchMeetingMembers() {
        Task {
            do {
                guard let responseBody = try await service.fetchMeetingMemberListExcludeLoginUser(with: builder.id),
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
