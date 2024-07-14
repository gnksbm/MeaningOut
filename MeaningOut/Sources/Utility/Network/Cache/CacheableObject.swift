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
    
    init?(value: Value, headers: [AnyHashable: Any]) {
        if let eTag = headers["ETag"] as? String {
            self.validationField = .eTag(eTag)
        } else if let lastModified = headers["Last-Modified"] as? String {
            self.validationField = .lastModified(lastModified)
        } else {
            return nil
        }
        self.value = value
    }
    
    func toURLRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(
            validationField.requestHeaderValue,
            forHTTPHeaderField: validationField.requestKey
        )
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        return urlRequest
    }
    
    enum ValidationField {
        case eTag(String), lastModified(String)
        
        var requestKey: String {
            switch self {
            case .eTag:
                "If-None-Match"
            case .lastModified:
                "If-Modified-Since"
            }
        }
        
        var requestHeaderValue: String {
            switch self {
            case .eTag(let eTag):
                eTag
            case .lastModified(let modifiedDate):
                modifiedDate
            }
        }
    }
}
