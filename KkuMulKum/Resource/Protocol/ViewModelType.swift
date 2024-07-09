//
//  ViewModelType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: RxSwift.DisposeBag) -> Output
}
