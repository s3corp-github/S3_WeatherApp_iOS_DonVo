//
//  BaseResponse.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

struct BaseResponse<T: Decodable> : Decodable {
    var data: T
}
