//
//  BaseEndpoint.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

typealias Parameters = [String : Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Endpoint {
    var key: String { get }
    var httpMethods: HTTPMethod { get }
    var params: Parameters? { get }
    var baseUrl: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var key: String {
        return  "712fe930090e454885631934222911"
    }

    var url: String {
        return baseUrl + path
    }
}
