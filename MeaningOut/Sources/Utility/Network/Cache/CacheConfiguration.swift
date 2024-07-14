//
//  CacheConfiguration.swift
//  MeaningOut
//
//  Created by gnksbm on 7/14/24.
//

import Foundation

struct CacheConfiguration {
    static let `default` = CacheConfiguration(
        totalCostLimit: DataSize(amount: 0),
        countLimit: DataSize(amount: 0)
    )
    
    let totalCostLimit: Int
    let countLimit: Int
    
    init(totalCostLimit: DataSize, countLimit: DataSize) {
        self.totalCostLimit = totalCostLimit.toBytes
        self.countLimit = countLimit.toBytes
    }
}
