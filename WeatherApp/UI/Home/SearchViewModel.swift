//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

protocol CityListProtocol {
    var didGetCityListFromAPI: (([String]) -> Void)? { get set }
    var didFailWithError: ((APIError) -> Void)? { get set }

    func getCityList(with input: String)
}

protocol RecentCityProtocol {
    var didGetRecentCityList: (([String]) -> Void)? { get set }

    func getRecentCity()
    func updateRecentCity(recent: String)
}

protocol SearchViewModelProtocol: CityListProtocol, RecentCityProtocol {
    var cityList: [String] { get set }
}

class SearchViewModel: SearchViewModelProtocol {
    private let userDefaults = UserDefaults.standard

    var cityList: [String] = []
    var previousSearchPattern: String = ""
    var didGetCityListFromAPI: (([String]) -> Void)?
    var didGetRecentCityList: (([String]) -> Void)?
    var didFailWithError: ((APIError) -> Void)?

    func getCityList(with input: String) {
        let handleInput = input.handleWhiteSpace()
        guard handleInput != previousSearchPattern else { return }
        previousSearchPattern = handleInput

        let service = SearchService.init(pattern: handleInput)
        Network.shared().request(with: service.url) { [weak self] (result: (Result<CityData,APIError>)) in
            switch result {
            case .success(let data):
                let result = data.searchApi.result
                let list = CityList(result: result, matchPattern: service.pattern)
                self?.didGetCityListFromAPI?(list.cityList)
            case .failure(let error):
                self?.didFailWithError?(error)
            }
        }
    }

    func getRecentCity() {
        previousSearchPattern = ""
        let recenCity = userDefaults.object(forKey: "recentCity") as? [String] ?? []
        didGetRecentCityList?(recenCity)
    }

    func updateRecentCity(recent: String) {
        var recenCity = userDefaults.object(forKey: "recentCity") as? [String] ?? []
        if let index = recenCity.firstIndex(of: recent) {
            recenCity.remove(at: index)
        }
        recenCity.insert(recent, at: 0)
        if recenCity.count > 10 {
            recenCity.removeLast()
        }
        userDefaults.set(recenCity, forKey: "recentCity")
    }
}
