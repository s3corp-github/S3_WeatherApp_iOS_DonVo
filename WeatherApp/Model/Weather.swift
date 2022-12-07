//
//  Weather.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

struct Weather {
    let tempC: String
    let description: [WeatherDesciption]
    let weatherIconUrl: [WeatherIcon]
    let humidity: String
    let name: String

    var nameString: String {
        var result = name
        if let index = name.firstIndex(of: ",") {
            result = String(result[..<index])
        }
        return result
    }

    var tempCString: String {
        return tempC
    }

    var formatedHumiditySring: String {
        return humidity.appending(" g/m³")
    }

    var descriptionString: String {
        return description.first?.value ?? ""
    }

    var weatherIconUrlString: String {
        return weatherIconUrl.first?.value ?? ""
    }
}

struct WeatherData: Decodable {
    let condition: [WeatherCondition]
    let area: [WeatherArea]

    enum CodingKeys: String, CodingKey {
        case condition = "current_condition"
        case area = "request"
    }
}

struct WeatherArea: Decodable {
    let city: String

    enum CodingKeys: String, CodingKey {
        case city = "query"
    }
}

struct WeatherCondition: Decodable {
    let tempC: String
    let description: [WeatherDesciption]
    let weatherIconUrl: [WeatherIcon]
    let humidity: String

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_C"
        case description = "weatherDesc"
        case weatherIconUrl = "weatherIconUrl"
        case humidity = "humidity"
    }
}

struct WeatherIcon: Decodable {
    let value: String
}

struct WeatherDesciption: Decodable {
    let value: String
}
