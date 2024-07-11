//
//  WelcomeVIew.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import SnapKit
import Then

class WelcomeView: BaseView {
     let characterImageView = UIImageView().then {
          $0.image = UIImage(named: "img_logo")
          $0.contentMode = .scaleAspectFit
     }
     
     let welcomeLabel = UILabel().then {
          $0.textAlignment = .center
          $0.font = .pretendard(.body01)
     }
     
     let confirmButton = UIButton().then {
          $0.setTitle("확인", for: .normal)
          $0.setTitleColor(.white, for: .normal)
          $0.backgroundColor = .maincolor
          $0.layer.cornerRadius = 8
     }
     
     override func setupView() {
          addSubviews(characterImageView, welcomeLabel,confirmButton)
        
     }
     
     override func setupAutoLayout() {
          characterImageView.snp.makeConstraints {
               $0.top.equalTo(safeAreaLayoutGuide).offset(200)
               $0.centerX.equalToSuperview()
               $0.height.width.equalTo(150)
          }
          
          welcomeLabel.snp.makeConstraints {
               $0.top.equalTo(characterImageView.snp.bottom).offset(20)
               $0.centerX.equalToSuperview()
          }
          
          confirmButton.snp.makeConstraints {
               $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
               $0.leading.trailing.equalToSuperview().inset(20)
               $0.height.equalTo(50)
          }
     }
     
     func configure(with nickname: String) {
           welcomeLabel.text = "\(nickname)님 반가워요!"
       }
}
