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
        return .get
    }

    var params: Parameters? {
        switch self {
        case .getWeather(let city):
            return ["key": key,
                    "format": "json",
                    "q": city]
        }
    }

    var baseUrl: String {
        return "https://api.worldweatheronline.com/"
    }

    var headers: [String : Any]? {
        switch self {
        case .getWeather:
            return ["Content-Type": "application/json"]
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getWeather:
            return [:]
        }
    }

    var path: String {
        return "/premium/v1/weather.ashx"
    }
}
