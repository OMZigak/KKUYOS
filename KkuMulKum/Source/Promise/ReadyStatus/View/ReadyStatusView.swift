//
//  ReadyStatusView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class ReadyStatusView: BaseView {
    private let enterReadyButtonView: EnterReadyInfoButtonView = EnterReadyInfoButtonView()
    
    private let readyPlanInfoView: ReadyPlanInfoView = ReadyPlanInfoView()
    
    private let myReadyStatusTitleLabel: UILabel = UILabel().then {
        $0.setText("나의 준비 현황", style: .body01, color: .gray8)
    }
    
    private let 
}
