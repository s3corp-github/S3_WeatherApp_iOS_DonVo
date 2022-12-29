//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

protocol WeatherInformationProtocol {
    func getWeatherDetail(city: String)
}

protocol CityViewModelProtocol: WeatherInformationProtocol {
    var didGetWeather: ((WeatherDataType) -> Void)? { get set }
    var didFailWithError: ((APIError) -> Void)? { get set }
}

class CityViewModel: CityViewModelProtocol {
    var didGetWeather: ((WeatherDataType) -> Void)?
    var didFailWithError: ((APIError) -> Void)?

    let weatherService: WeatherServiceProtocol

    init(service: WeatherServiceProtocol = WeatherService.init()) {
        self.weatherService = service
    }

    func getWeatherDetail(city: String ) {
        weatherService.getWeather(city: city) { [weak self] result in
            switch result {
            case .success(let data):
                self?.didGetWeather?(data)
            case .failure(let error):
                self?.didFailWithError?(error)
            }
        }
    }
}
