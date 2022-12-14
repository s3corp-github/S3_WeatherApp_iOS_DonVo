//
//  SearchService.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

struct SearchService {
    var pattern: String
}

extension SearchService: BaseService {
    var params: Parameters {
        return ["key": key,
                "format": "json",
                "q": pattern]
    }

    var path: String {
        return "premium/v1/search.ashx"
    }
}
