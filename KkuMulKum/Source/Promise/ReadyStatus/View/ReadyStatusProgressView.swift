//
//  ReadyStatusProgressView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import UIKit

class ReadyStatusProgressView: BaseView {
    private let statusProgressView: UIProgressView = UIProgressView().then {
        $0.trackTintColor = .gray2
        $0.progressTintColor = .maincolor
    }
    
    private let readyStartTimeLabel: UILabel = UILabel().then {
        $0.setText("AM hh:mm", style: .caption02, color: .gray8)
    }
    
    private let readyStartCheckImageView: UIImageView = UIImageView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = Screen.height(16 / 2)
        $0.clipsToBounds = true
    }
    
    private let 
    
    private let moveStartTimeLabel: UILabel = UILabel().then {
        $0.setText("AM hh:mm", style: .caption02, color: .gray8)
    }
    
    private let moveStartCheckImageView: UIImageView = UIImageView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = Screen.height(16 / 2)
        $0.clipsToBounds = true
    }
    
    private let arrivalTimeLabel: UILabel = UILabel().then {
        $0.setText("AM hh:mm", style: .caption02, color: .gray8)
    }
    
    private let arrivalCheckImageView: UIImageView = UIImageView(backgroundColor: .gray2).then {
        $0.layer.cornerRadius = Screen.height(16 / 2)
        $0.clipsToBounds = true
    }
}
