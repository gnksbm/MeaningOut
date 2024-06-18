//
//  UserDefaultsWrapper.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation
/**
 UserDefaultsKey를 정의해 UserDefaults에 잘못된 키나 중복된 키로 접근을 방지
 */
enum UserDefaultsKey: String {
    case profileNickname, profileImageName, searchHistory, joinedDate, 
         favoriteProductID
}
/**
 프로퍼티래퍼로 UserDefaults를 간편하게 사용
 */
@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    private let key: UserDefaultsKey
    private var defaultValue: T
    
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
    
    var isSaved: Bool {
        UserDefaults.standard.data(forKey: key.rawValue) != nil
    }
    
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    mutating func updateDefaultValue(newValue: T) {
        defaultValue = newValue
    }
}
