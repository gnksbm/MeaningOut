//
//  Builder.swift
//  MeaningOut
//
//  Created by gnksbm on 6/13/24.
//

import Foundation

protocol Buildable { }

extension Buildable where Self: AnyObject {
    /**
     클로저 구문 안에서 Builder로 객체의 프로퍼티 값을 변경하거나 함수 실행
     - Parameter block: Builder를 반환하는 subscript나 action 메서드를 체이닝 형태로 사용,
     클로저 내부에서 Builder<객체> 타입을 반환해야함
     - Returns: Builder<객체>가 언래핑되어 블록 안에서 설정한 객체 반환
     */
    func build(_ block: (_ builder: Builder<Self>) -> Builder<Self>) -> Self {
        block(Builder(self)).build()
    }
}

extension NSObject: Buildable { }
/**
 객체의 설정을 메서드 체이닝 형태로 구현할 수 있는 래핑 객체
 - 변수 선언과 호출, return문 등의 반복을 줄여 간결한 코드 작성 가능
 - dynamicMemberLookup을 사용한 구현으로 View, Controller 객체의 프로퍼티에 접근이 가능하며
 subscript의 반환형을 클로저 형태로 구현하여 SwiftUI의 Modifier처럼 프로퍼티 값 할당 가능
 */
@dynamicMemberLookup
struct Builder<Base: AnyObject> {
    private let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>
    ) -> ((_ newValue: Value) -> Builder<Base>) {
        { newValue in
            base[keyPath: keyPath] = newValue
            return Builder(base)
        }
    }
    
    func action(_ block: (Base) -> Void) -> Builder<Base> {
        block(base)
        return Builder(base)
    }
    
    fileprivate func build() -> Base {
        base
    }
}
