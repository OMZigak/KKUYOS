//
//  MeetingListViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/13/24.
//

import Foundation

import RxCocoa
import RxSwift

final class MeetingListViewModel {
    private let loginUserRelay = BehaviorRelay<LoginUserModel?>(value: nil)
    private let meetingListRelay = BehaviorRelay<MeetingListModel?>(value: nil)
    
    private let service: MeetingListServiceProtocol
    
    init(service: MeetingListServiceProtocol) {
        self.service = service
    }
}

extension MeetingListViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: PublishRelay<Void>
        let meetingCellDidSelect: PublishRelay<Int>
    }
    
    struct Output {
        let info: Driver<(String, Int)>
        let meetingCount: Driver<Int>
        let meetings: Driver<[Meeting]>
        let navigateToMeetingInfo: Driver<Int>
    }
    
    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.requestLoginUser()
                owner.requestMeetingList()
            }
            .disposed(by: disposeBag)
        
        let userName = loginUserRelay
            .compactMap { $0?.name }
            .asDriver(onErrorJustReturn: "꾸물리안")
        
        let meetingCount = meetingListRelay
            .compactMap { $0?.count }
            .asDriver(onErrorJustReturn: 0)
        
        let meetings = meetingListRelay
            .compactMap { $0?.meetings }
            .asDriver(onErrorJustReturn: [])
        
        let info = Driver.combineLatest(userName, meetingCount) { ($0, $1) }
        
        let navigateToMeetingInfo = input.meetingCellDidSelect
            .withLatestFrom(meetings) { index, meetings in
                return meetings[index].meetingID
            }
            .asDriver(onErrorJustReturn: 0)
        
        let output = Output(
            info: info,
            meetingCount: meetingCount,
            meetings: meetings,
            navigateToMeetingInfo: navigateToMeetingInfo
        )
        
        return output
    }
}

private extension MeetingListViewModel {
    func requestLoginUser() {
        Task {
            do {
                let responseBody = try await service.fetchLoginUser()
                loginUserRelay.accept(responseBody?.data)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func requestMeetingList() {
        Task {
            do {
                let responseBody = try await service.fetchMeetingList()
                meetingListRelay.accept(responseBody?.data)
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
