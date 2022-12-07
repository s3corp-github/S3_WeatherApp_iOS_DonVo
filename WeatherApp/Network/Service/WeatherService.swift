//
//  WeatherService.swift
//  WeatherApp
//
//  Created by don.vo on 12/1/22.
//

import Foundation

enum WeatherService {
    case getWeather(String)
}

extension WeatherService: BaseService {
    var params: Parameters {
        switch self {
        case .getWeather(let location):
            return ["key": key,
                    "format": "json",
                    "q": location]
        }
    }

    var path: String {
        return "premium/v1/weather.ashx"
    }
}
