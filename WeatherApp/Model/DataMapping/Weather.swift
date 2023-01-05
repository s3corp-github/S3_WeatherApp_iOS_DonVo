//
//  Weather.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

protocol WeatherDataType {
    var name: String? { get }
    var tempC: String? { get }
    var humidity: String? { get }
    var description: String? { get }
    var iconUrl: String? { get }
}

struct WeatherData: Decodable, WeatherDataType {
    let condition: [WeatherCondition]
    let area: [WeatherArea]

    enum CodingKeys: String, CodingKey {
        case condition = "current_condition"
        case area = "request"
    }
}

extension WeatherData {
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
}

extension WeatherData {
    var name: String? {
        return area.first?.city
    }

    var tempC: String? {
        let tempC = condition.first?.tempC
        return tempC?.appending("°C")
    }

    var humidity: String? {
        let humidity = condition.first?.humidity
        return humidity?.appending(" g/m³")
    }

    var description: String? {
        return condition.first?.description.first?.value
    }

    var iconUrl: String? {
        return condition.first?.weatherIconUrl.first?.value
    }
}
