//
//  Array+patternMatching.swift
//  WeatherApp
//
//  Created by don.vo on 12/2/22.
//

import Foundation

extension Array where Element == String {
    func getElementMatching(pattern: String) -> [String] {
        return self.filter {
            $0.lowercased().contains(pattern.lowercased())
        }
    }
}
