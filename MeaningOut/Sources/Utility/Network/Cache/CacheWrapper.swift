//
//  CacheWrapper.swift
//  MeaningOut
//
//  Created by gnksbm on 7/14/24.
//

import Foundation

@propertyWrapper
struct CacheWrapper<Value> {
    private let url: URL
    private let config: CacheConfiguration
    
    init(url: URL, config: CacheConfiguration = .default) {
        self.url = url
        self.config = config
    }
    
    var wrappedValue: CacheableObject<Value>? {
        get {
            CacheStorage.object(url: url, config: config)
        }
        set {
            guard let newValue else { return }
            CacheStorage.setObject(newValue, url: url, config: config)
        }
    }
}
