//
//  ObservablePattern.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/4/24.
//

import Foundation

class ObservablePattern<T> {
    var value: T {
        didSet {
            notifyListeners(value)
        }
    }
    
    typealias Listener = (T) -> Void
    
    private var listeners: [Listener] = []
    
    init(_ value: T) {
        self.value = value
    }
    
    private func notifyListeners(_ value: T) {
        for listener in listeners {
            listener(value)
        }
    }
    
    func bind(_ listener: @escaping (T) -> Void) {
        listeners.append(listener)
    }
    
    func bind<Object: AnyObject>(with object: Object, _ listener: @escaping (Object, T) -> Void) {
        listeners.append { [weak object] value in
            guard let object else { return }
            listener(object, value)
        }
    }
    
    func bindOnMain(_ listener: @escaping (T) -> Void) {
        listeners.append { value in
            DispatchQueue.main.async {
                listener(value)
            }
        }
    }
    
    func bindOnMain<Object: AnyObject>(with object: Object, _ listener: @escaping (Object, T) -> Void) {
        listeners.append { [weak object] value in
            guard let object else { return }
            DispatchQueue.main.async {
                listener(object, value)
            }
        }
    }
}
