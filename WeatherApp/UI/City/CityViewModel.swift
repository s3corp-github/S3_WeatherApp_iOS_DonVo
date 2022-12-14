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

    func getWeatherDetail(with service: WeatherService)
}

protocol CityViewModelProtocol: WeatherInformationProtocol {}

struct CityViewModel: CityViewModelProtocol {
    var didGetWeather: ((Weather) -> Void)?
    var didFailWithError: ((APIError) -> Void)?

    func getWeatherDetail(with service: WeatherService) {
        Network.shared().request(with: service.url) { (result: (Result<BaseResponse<WeatherData>, APIError>)) in
            switch result {
            case .success(let decodedData):
                guard let condition = decodedData.data.condition.first else {
                    didFailWithError?(.errorDataNotExist)
                    return
                }
                guard let area = decodedData.data.area.first else {
                    didFailWithError?(.errorDataNotExist)
                    return
                }
                let weather = Weather(
                    tempC: condition.tempC,
                    description: condition.description,
                    weatherIconUrl: condition.weatherIconUrl,
                    humidity: condition.humidity,
                    name: area.city)
                didGetWeather?(weather)
            case .failure(let error):
                didFailWithError?(error)
            }
        }
    }
}
