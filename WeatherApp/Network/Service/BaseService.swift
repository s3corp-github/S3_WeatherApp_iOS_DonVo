//
//  BaseService.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

typealias Parameters = [String : Any]

protocol BaseService {
    var key: String { get }
    var params: Parameters { get }
    var baseUrl: String { get }
    var path: String { get }
    var url: String { get }
}

extension BaseService {
    var key: String {
        return  "712fe930090e454885631934222911"
    }

    var baseUrl: String {
        return "https://api.worldweatheronline.com/"
    }

    var url: String {
        var urlString = baseUrl + path
        var flag = 0
        for (key, value) in params {
            if flag == 0 {
                urlString.append("?")
                urlString.append("\(key)=\(value)")
                flag = 1
            } else {
                urlString.append("&")
                urlString.append("\(key)=\(value)")
            }
            urlString.append("")
        }
        return urlString
    }
}
