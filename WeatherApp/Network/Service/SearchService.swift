//
//  SearchService.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

enum SearchService {
    case searchCity(String)
}

extension SearchService: BaseService {
    var params: Parameters {
        switch self {
        case .searchCity(let pattern):
            return ["key": key,
                    "format": "json",
                    "q": pattern]
        }
    }

    var path: String {
        return "premium/v1/search.ashx"
    }
}
