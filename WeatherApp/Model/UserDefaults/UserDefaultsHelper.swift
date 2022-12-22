//
//  UserDefaultsHelper.swift
//  WeatherApp
//
//  Created by don.vo on 12/22/22.
//

import Foundation

final class UserDefaultsHelper {
    private static var defaults = UserDefaults.standard

    static func setData<T>(value: T, key: UserDefaultKeys) {
        defaults.set(value, forKey: key.rawValue)
    }

    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }

    static func removeData(key: UserDefaultKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }

    static func clearAll() {
        _ = UserDefaultKeys.allCases.map({ removeData(key: $0) })
    }
}
