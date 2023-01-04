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
            return .get
        }
    }

    var baseUrl: String {
        return "https://api.worldweatheronline.com/"
    }

    var params: Parameters? {
        switch self {
        case .getCityList(let pattern):
            return ["key": key,
                    "format": "json",
                    "q": pattern]
        }
    }

    var headers: [String : Any]? {
        switch self {
        case .getCityList:
            return ["Content-Type": "application/json"]
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getCityList:
            return [:]
        }
    }

    var path: String {
        return "/premium/v1/search.ashx"
    }
}
