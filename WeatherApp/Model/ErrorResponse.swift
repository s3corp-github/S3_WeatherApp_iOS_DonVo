//
//  ErrorResponse.swift
//  WeatherApp
//
//  Created by don.vo on 12/2/22.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: [ErrorMessageResponse]
}

struct ErrorMessageResponse: Decodable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message = "msg"
    }
}
