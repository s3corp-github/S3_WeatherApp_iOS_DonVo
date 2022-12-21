//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

protocol WeatherInformationProtocol {
    var didGetWeather: ((Weather) -> Void)? { get set }
    var didFailWithError: ((APIError) -> Void)? { get set }

    func getWeatherDetail(city: String)
}

protocol CityViewModelProtocol: WeatherInformationProtocol {}

class CityViewModel: CityViewModelProtocol {
    var didGetWeather: ((Weather) -> Void)?
    var didFailWithError: ((APIError) -> Void)?

    let weatherService: WeatherService

    init(service: WeatherService) {
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
