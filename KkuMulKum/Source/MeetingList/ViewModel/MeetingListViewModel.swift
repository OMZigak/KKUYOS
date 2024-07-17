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
    
    private let service: MeetingListServiceType
    
    init(service: MeetingListServiceType) {
        self.service = service
    }
    
    func requestMeetingList() {
        meetingList.value = service.fetchMeetingList()
    }
}
