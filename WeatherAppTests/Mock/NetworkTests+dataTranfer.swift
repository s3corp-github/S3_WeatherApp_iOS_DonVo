//
//  NetworkTests+dataTranfer.swift
//  WeatherAppTests
//
//  Created by don.vo on 1/5/23.
//

import Foundation
@testable import WeatherApp

extension NetworkTests {
    struct EndointMock: Endpoint {
        var httpMethods: HTTPMethod
        var params: Parameters? = [:]
        var baseUrl: String = "https://httpstat.us"
        var path: String
        var headers: [String : Any]? = ["Accept": "application/json"]
        var body: [String : Any]? = [:]
    }

    struct responseMock: Decodable {
        var code: Int
        var description: String
    }
}
