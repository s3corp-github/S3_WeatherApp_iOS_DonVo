//
//  SearchEndpoint.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

enum SearchEndpoint {
    case getCityList(pattern: String)
}

extension SearchEndpoint: Endpoint {
    var httpMethods: HTTPMethod {
        switch self {
        case .getCityList:
            return .GET
        }
    }

    var params: Parameters {
        switch self {
        case .getCityList(let pattern):
            return ["key": key,
                    "format": "json",
                    "q": pattern]
        }
    }

    var path: String {
        return "premium/v1/search.ashx"
    }
}
