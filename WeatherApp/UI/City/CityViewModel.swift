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
    private let baseUrl = "https://api.worldweatheronline.com/premium/v1/weather.ashx?key=712fe930090e454885631934222911&format=json"

    func fetchWeather(at city: String) {
        let url = "\(baseUrl)&q=\(city)"
        getWeatherDetail(url: url)
    }

    private func getWeatherDetail(url: String) {
        Networking.shared().request(with: url) { result in
            switch result {
            case .success(let data):
                parseJson(with: data)
            case .failure(let error):
                delegate?.didFailWithError(self, error: error)
            }
        }
    }

    private func parseJson(with data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<WeatherData>.self, from: data)
            guard let condition = decodeData.data.condition.first else { return }
            let weather = Weather(
                tempC: condition.tempC,
                description: condition.description,
                weatherIconUrl: condition.weatherIconUrl,
                humidity: condition.humidity)
            delegate?.didUpdateWeatherCondition(self, weatherModel: weather)
        } catch {
            delegate?.didFailWithError(self, error: APIError.error("Can not decode data"))
        }
    }
}
