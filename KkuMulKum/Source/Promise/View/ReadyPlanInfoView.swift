//
//  ReadyPlanInfoView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/10/24.
//

import UIKit

class ReadyPlanInfoView: BaseView {
    private let readyTimeLabel: UILabel = UILabel().then {
        $0.setText("12시 30분에 준비하고,\n1시에 이동을 시작해야 해요", style: .body03)
        $0.setHighlightText("12시 30분", style: .body03, color: .maincolor)
    }
    
}
