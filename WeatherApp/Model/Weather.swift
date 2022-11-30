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

    enum CodingKeys: String, CodingKey {
        case condition = "current_condition"
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
