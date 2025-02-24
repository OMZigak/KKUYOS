//
//  Pulse.swift
//  KkuMulKum
//
//  Created by 이지훈 on 2/24/25.
//

import Foundation

/// 일회성 이벤트를 관리하기 위한 클래스
class Pulse<T> {
    typealias Listener = (T) -> Void
    
    private var value: T?
    private var listeners: [Listener] = []
    private var isConsumed = false
    
    /// 새로운 Pulse 생성
    init() {}
    
    /// 값 발신
    func emit(_ value: T) {
        guard !isConsumed else { return }
        
        self.value = value
        isConsumed = true
        
        // 모든 리스너에게 값 전달
        listeners.forEach { $0(value) }
        
        // 발신 후 리스너 비우기
        listeners.removeAll()
    }
    
    /// 리스너 등록
    func subscribe(_ listener: @escaping Listener) {
        if let value = value, isConsumed {
            // 이미 값이 발신되었다면 즉시 전달
            listener(value)
        } else {
            // 아직 값이 없다면 리스너 등록
            listeners.append(listener)
        }
    }
    
    /// 약한 참조로 리스너 등록
    func subscribe<O: AnyObject>(with object: O, listener: @escaping (O, T) -> Void) {
        let wrappedListener: Listener = { [weak object] value in
            guard let object = object else { return }
            listener(object, value)
        }
        
        if let value = value, isConsumed {
            // 이미 값이 발신되었다면 즉시 전달
            wrappedListener(value)
        } else {
            // 아직 값이 없다면 리스너 등록
            listeners.append(wrappedListener)
        }
    }
    
    /// 모든 리스너 제거
    func reset() {
        value = nil
        isConsumed = false
        listeners.removeAll()
    }
}
