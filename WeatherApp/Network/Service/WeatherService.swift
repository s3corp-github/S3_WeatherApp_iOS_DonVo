//
//  WeatherService.swift
//  WeatherApp
//
//  Created by don.vo on 12/21/22.
//

import Foundation

class WeatherService {
    func getWeather(city: String, completion: @escaping (Result<Weather, APIError>) -> Void ) {
        let getWeatherEndpoint = WeatherEndpoint.getWeather(city: city)
        Network.shared().request(with: getWeatherEndpoint) { (result: (Result<BaseResponse<WeatherData>, APIError>)) in
            switch result {
            case .success(let decodedData):
                guard let condition = decodedData.data.condition.first else {
                    completion(.failure(.errorDataNotExist))
                    return
                }
                guard let area = decodedData.data.area.first else {
                    completion(.failure(.errorDataNotExist))
                    return
                }
                let weather = Weather(
                    tempC: condition.tempC,
                    description: condition.description,
                    weatherIconUrl: condition.weatherIconUrl,
                    humidity: condition.humidity,
                    name: area.city)
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
