//
//  ReuseIdentifiable.swift
//  KkuMulKum
//
//  Created by 김진웅 on 6/30/24.
//

import Foundation

protocol ReuseIdentifiable {}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { String(describing: self) }
}
