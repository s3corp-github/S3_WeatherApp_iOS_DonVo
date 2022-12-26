//
//  City.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

protocol CityDataType {
    var cityList: [String] { get }

    func getCityListMatchPattern(pattern: String) -> [String]
}

struct CityData: Decodable, CityDataType {
    let searchApi: CityResult

    enum CodingKeys: String, CodingKey {
        case searchApi = "search_api"
    }
}

extension CityData {
    struct CityResult: Decodable {
        let result: [Area]
    }

    struct Area: Decodable {
        let areaName: [AreaName]
    }

    struct AreaName: Decodable {
        let value: String
    }
}

extension CityData {
    var cityList: [String] {
        get {
            return searchApi.result.compactMap {
                $0.areaName.first?.value
            }
        }
    }

    func getCityListMatchPattern(pattern: String) -> [String] {
        return cityList.getElementMatching(pattern: pattern)
    }
}
