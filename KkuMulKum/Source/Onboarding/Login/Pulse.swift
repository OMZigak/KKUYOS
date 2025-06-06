//
//  Pulse.swift
//  KkuMulKum
//
//  Created by 이지훈 on 2/24/25.
//

import Foundation

/// 일회성 이벤트를 관리하기 위한 제네릭 클래스
/// Pulse는 이벤트를 한 번만 전달하고, 이후 추가 구독자에게는 마지막 이벤트를 즉시 전달하는 메커니즘을 제공합니다.
class Pulse<T> {
    /// 리스너 타입 정의 (이벤트 핸들러)
    typealias Listener = (T) -> Void
    
    /// 현재 저장된 값
    private var value: T?
    
    /// 등록된 리스너 목록
    private var listeners: [Listener] = []
    
    /// 이벤트가 이미 소비되었는지 추적하는 플래그
    private var isConsumed = false
    
    /// 새로운 Pulse 인스턴스 생성
    init() {}
    
    /// 이벤트 값을 전달하고 모든 리스너에게 알림
    /// - Parameter value: 전달할 이벤트 값
    /// - Note: 이벤트는 한 번만 전달되며, 이후 추가 emit은 무시됨
    func emit(_ value: T) {
        guard !isConsumed else { return }
        
        self.value = value
        isConsumed = true
        
        // 모든 리스너에게 값 전달
        listeners.forEach { $0(value) }
        
        // 발신 후 리스너 비우기
        listeners.removeAll()
    }
    
    /// 리스너를 등록하고 이미 발행된 이벤트가 있다면 즉시 전달
    /// - Parameter listener: 이벤트를 처리할 클로저
    func subscribe(_ listener: @escaping Listener) {
        if let value = value, isConsumed {
            // 이미 값이 발신되었다면 즉시 전달
            listener(value)
        } else {
            // 아직 값이 없다면 리스너 등록
            listeners.append(listener)
        }
    }
    
    /// 약한 참조로 리스너를 등록하고 이미 발행된 이벤트가 있다면 즉시 전달
    /// - Parameters:
    ///   - object: 리스너가 속한 약한 참조 객체
    ///   - listener: 이벤트를 처리할 클로저 (객체와 값을 받음)
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
    
    /// 모든 상태를 초기화하여 Pulse를 재사용 가능한 상태로 만듦
    func reset() {
        value = nil
        isConsumed = false
        listeners.removeAll()
    }
}
