//
//  WeatherService.swift
//  WeatherApp
//
//  Created by don.vo on 12/21/22.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeather(city: String, completion: @escaping (Result<WeatherDataType, APIError>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    let network: Network

    init(network: Network = .shared()) {
        self.network = network
    }

    func getWeather(city: String, completion: @escaping (Result<WeatherDataType, APIError>) -> Void ) {
        let getWeatherEndpoint = WeatherEndpoint.getWeather(city: city)
        network.request(with: getWeatherEndpoint) { (result: (Result<BaseResponse<WeatherData>, APIError>)) in
            switch result {
            case .success(let decodedData):
                let weatherData = decodedData.data
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
