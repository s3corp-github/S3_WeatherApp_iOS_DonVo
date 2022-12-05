//
//  String+handleWhiteSpace.swift
//  WeatherApp
//
//  Created by don.vo on 12/5/22.
//

import Foundation

extension String {
    func handleWhiteSpace() -> String {
        var trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedString = trimmedString.components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        return trimmedString
    }
}
