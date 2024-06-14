//
//  UserDefaultsWrapper.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

enum UserDefaultsKey: String {
    case profileNickname, profileImageName
}

@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    private let key: UserDefaultsKey
    private let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue)
            else {
                Logger.debugging("\(key.rawValue): 저장된 데이터 없음")
                return defaultValue
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                Logger.error(error)
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key.rawValue)
            } catch {
                Logger.error(error)
            }
        }
    }
    
    init(key: UserDefaultsKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
