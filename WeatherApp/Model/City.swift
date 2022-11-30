//
//  City.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

struct CityList: Decodable {
    let result: [Area]

    var cityList: [String] {
        var list: [String] = []
        for val in result {
            guard let area = val.areaName.first else { continue }
            let cityName = area.value
            list.append(cityName)
        }
        return list
    }
}

struct CityData: Decodable {
    let searchApi: CityResult

    enum CodingKeys: String, CodingKey {
        case searchApi = "search_api"
    }
}

struct CityResult: Decodable {
    let result: [Area]
}

struct Area: Decodable {
    let areaName: [AreaName]
}

struct AreaName: Decodable {
    let value: String
}
