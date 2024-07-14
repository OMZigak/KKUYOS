//
//  FindPlaceViewModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class FindPlaceViewModel {
    private let service: FindPlaceServiceType
    
    init(service: FindPlaceServiceType) {
        self.service = service
    }
}

extension FindPlaceViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
