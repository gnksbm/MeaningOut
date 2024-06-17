//
//  APIKey.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import Foundation

enum APIKey {
    static var naverID: String {
        Bundle.main.object(forInfoDictionaryKey: "NAVER_ID") as? String ?? ""
    }
    
    static var naverSecret: String {
        Bundle.main.object(
            forInfoDictionaryKey: "NAVER_SECRET"
        ) as? String ?? ""
    }
}
