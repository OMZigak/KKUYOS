//
//  MeetingListViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/13/24.
//

import UIKit

import Then

final class MeetingListViewModel {
    var meetingListData = ObservablePattern<[MeetingDummyModel]>([])
    
    /// 더미 함수 이후에 삭제
    func dummy() {
        meetingListData.value = MeetingDummyModel.dummy()
    }
    
    func updateContentData(newData: [MeetingDummyModel]) {
        meetingListData.value = newData
    }
}
