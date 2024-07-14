//
//  CacheableObject.swift
//  MeaningOut
//
//  Created by gnksbm on 7/14/24.
//

import Foundation

final class CacheableObject<Value>: ReuseIdentifiable {
    let value: Value
    let validationField: ValidationField
    
    init(value: Value, validationField: ValidationField) {
        self.value = value
        self.validationField = validationField
    }
    
    enum ValidationField {
        case eTag(String), lastModified(String)
    }
}
