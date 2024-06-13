//
//  Builder.swift
//  MeaningOut
//
//  Created by gnksbm on 6/13/24.
//

import Foundation

protocol Buildable { }

extension Buildable where Self: AnyObject {
    func build(_ block: (_ builder: Builder<Self>) -> Builder<Self>) -> Self {
        block(Builder(self)).build()
    }
}

extension NSObject: Buildable { }

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

