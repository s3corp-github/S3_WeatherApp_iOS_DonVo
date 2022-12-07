//
//  Array+patternMatching.swift
//  WeatherApp
//
//  Created by don.vo on 12/2/22.
//

import Foundation

extension Array where Element == String {
    func getElementMatching(pattern: String) -> [String] {
        var result: [String] = []
        for val in self {
            if val.lowercased().contains(pattern.lowercased()) {
                result.append(val)
            }
        }
        return result
    }
}
