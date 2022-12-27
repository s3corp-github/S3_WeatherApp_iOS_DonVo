//
//  CacheProperties.swift
//  WeatherApp
//
//  Created by don.vo on 12/27/22.
//

import Foundation

extension CacheHelper {
    final class WrappedKey: NSObject {
        let key: Key
        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}

extension CacheHelper {
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}
