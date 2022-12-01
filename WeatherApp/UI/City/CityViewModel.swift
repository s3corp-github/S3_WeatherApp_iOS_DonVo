//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

protocol CityViewModelDelegate: AnyObject {
    func didUpdateWeatherCondition(_ model: CityViewModel, weatherModel: Weather)
    func didFailWithError(_ model: CityViewModel, error: APIError)
}

struct CityViewModel {
    weak var delegate: CityViewModelDelegate?

    func fetchWeather(at city: String) {
        let service: WeatherService = .getWeather(city)
        getWeatherDetail(url: service.url)
    }

    private func getWeatherDetail(url: String) {
        Network.shared().request(with: url) { (result: (Result<BaseResponse<WeatherData>, APIError>)) in
            switch result {
            case .success(let decodedData):
                guard let condition = decodedData.data.condition.first else { return }
                let weather = Weather(
                    tempC: condition.tempC,
                    description: condition.description,
                    weatherIconUrl: condition.weatherIconUrl,
                    humidity: condition.humidity)
                delegate?.didUpdateWeatherCondition(self, weatherModel: weather)
            case .failure(let error):
                delegate?.didFailWithError(self, error: error)
            }
        }
    }
}
