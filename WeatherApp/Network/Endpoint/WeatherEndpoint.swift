//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by don.vo on 12/1/22.
//

import Foundation

enum WeatherEndpoint {
    case getWeather(city: String)
}

extension WeatherEndpoint: Endpoint {
    var httpMethods: HTTPMethod {
        return .GET
    }

    var params: Parameters {
        switch self {
        case .getWeather(let city):
            return ["key": key,
                    "format": "json",
                    "q": city]
        }
    }

    var path: String {
        return "premium/v1/weather.ashx"
    }
}
