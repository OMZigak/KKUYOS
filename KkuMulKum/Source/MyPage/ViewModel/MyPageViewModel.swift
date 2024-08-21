//
//  MyPageViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel {
    
    let editButtonTapped = PublishRelay<Void>()
    let pushEditProfileVC: Signal<Void>
    
    init() {
        pushEditProfileVC = editButtonTapped.asSignal()
        // 디버그 로그 추가
              editButtonTapped
                  .subscribe(onNext: {
                      print("Edit button tapped in ViewModel")
                  })
                  .disposed(by: DisposeBag())
          }
}
