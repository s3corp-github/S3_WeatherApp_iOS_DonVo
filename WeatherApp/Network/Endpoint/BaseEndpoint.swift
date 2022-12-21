//
//  BaseEndpoint.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

typealias Parameters = [String : Any]

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

protocol Endpoint {
    var key: String { get }
    var httpMethods: HTTPMethod { get}
    var params: Parameters { get }
    var baseUrl: String { get }
    var path: String { get }
    var url: String { get }
}

extension Endpoint {
    var key: String {
        return  "712fe930090e454885631934222911"
    }

    var baseUrl: String {
        return "https://api.worldweatheronline.com/"
    }

    var url: String {
        var urlString = baseUrl + path
        var isFirstParam = true
        for (key, value) in params {
            if isFirstParam == true {
                urlString.append("?")
                urlString.append("\(key)=\(value)")
                isFirstParam = false
            } else {
                urlString.append("&")
                urlString.append("\(key)=\(value)")
            }
            urlString.append("")
        }
        return urlString
    }
}
