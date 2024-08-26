//
//  MeetingListViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/13/24.
//

import UIKit

import Then

final class MeetingListViewModel {
    var meetingList = ObservablePattern<ResponseBodyDTO<MeetingListModel>?>(nil)
    
    private let service: MeetingListServiceProtocol
    
    init(service: MeetingListServiceProtocol) {
        self.service = service
    }
    
    func requestMeetingList() {
        Task {
            do {
                meetingList.value = try await service.fetchMeetingList()
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
