//
//  MeetingListViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/13/24.
//

import UIKit

import Then

final class MeetingListViewModel {
    var meetingListData = ObservablePattern<[MeetingDummyModel]>(MeetingDummyModel.dummy())
}
