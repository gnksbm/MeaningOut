//
//  CacheStorage.swift
//  MeaningOut
//
//  Created by gnksbm on 7/14/24.
//

import Foundation

enum CacheStorage {
    private static var cacheStorage = [String: any CacheService]()
    
    static func object<Value>(
        url: URL,
        config: CacheConfiguration
    ) -> CacheableObject<Value>? {
        savedCacheService(type: CacheableObject<Value>.self, config: config)
            .object(url: url)
    }
    
    static func setObject<Value>(
        _ object: CacheableObject<Value>,
        url: URL,
        config: CacheConfiguration
    ) where CacheableObject<Value>: ReuseIdentifiable {
        savedCacheService(type: CacheableObject<Value>.self, config: config)
            .setObject(object, url: url)
    }
    
    private static func savedCacheService<Value>(
        type: CacheableObject<Value>.Type,
        config: CacheConfiguration
    ) -> DefaultCacheService<Value> {
        if let service = cacheStorage[type.identifier],
           let anyCacheService = service as? DefaultCacheService<Value> {
            return anyCacheService
        } else {
            let service = DefaultCacheService<Value>(config: config)
            cacheStorage[type.identifier] = service
            return service
        }
    }
}
