//
//  CacheService.swift
//  MeaningOut
//
//  Created by gnksbm on 7/14/24.
//

import Foundation

protocol CacheService {
    associatedtype Value
    
    func object(url: URL) -> CacheableObject<Value>?
    func setObject(_ object: CacheableObject<Value>, url: URL)
}

final class DefaultCacheService<Value>: CacheService {
    let cache = NSCache<NSURL, CacheableObject<Value>>()
    
    init(config: CacheConfiguration = .default) {
        cache.countLimit = config.countLimit
        cache.totalCostLimit = config.totalCostLimit
    }
    
    func object(url: URL) -> CacheableObject<Value>? {
        cache.object(forKey: url as NSURL)
    }
    
    func setObject(_ object: CacheableObject<Value>, url: URL) {
        cache.setObject(object, forKey: url as NSURL)
    }
}
