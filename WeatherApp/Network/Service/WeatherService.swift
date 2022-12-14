//
//  WeatherService.swift
//  WeatherApp
//
//  Created by don.vo on 12/1/22.
//

import Foundation

struct WeatherService {
    var city: String
}

extension WeatherService: BaseService {
    var params: Parameters {
        return ["key": key,
                "format": "json",
                "q": city]
    }

    var path: String {
        return "premium/v1/weather.ashx"
    }
}
