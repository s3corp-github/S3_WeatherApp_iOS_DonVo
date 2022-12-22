//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

protocol CityListProtocol {
    var didGetCityListFromAPI: (([String], String) -> Void)? { get set }
    var didFailWithError: ((APIError, String) -> Void)? { get set }

    func getCityList(with input: String)
}

protocol RecentCityProtocol {
    var didGetRecentCityList: (([String]) -> Void)? { get set }

    func getRecentCity()
    func updateRecentCity(recent: String)
}

protocol SearchViewModelProtocol: CityListProtocol, RecentCityProtocol {
    var cityList: [String] { get set }
    var previousSearchPattern: String { get set }

    func getData(with input: String)
}

class SearchViewModel: SearchViewModelProtocol {
    let searchService: SearchService

    var cityList: [String] = []
    var previousSearchPattern: String = ""
    var didGetCityListFromAPI: (([String], String) -> Void)?
    var didGetRecentCityList: (([String]) -> Void)?
    var didFailWithError: ((APIError, String) -> Void)?

    init(service: SearchService) {
        self.searchService = service
    }

    func getData(with input: String) {
        let handleInput = input.handleWhiteSpace()
        guard handleInput != previousSearchPattern else { return }
        previousSearchPattern = handleInput

        if handleInput == "" {
            getRecentCity()
        } else {
            getCityList(with: handleInput)
        }
    }

    func getCityList(with input: String) {
        searchService.getCityList(pattern: input) { [weak self] result in
            switch result {
            case .success(let data):
                self?.didGetCityListFromAPI?(data, input)
            case .failure(let error):
                self?.didFailWithError?(error, input)
            }
        }
    }

    func getRecentCity() {
        let recenCity = UserDefaultsHelper.getData(type: [String].self, forKey: .recentCity) ?? []
        didGetRecentCityList?(recenCity)
    }

    func updateRecentCity(recent: String) {
        var recenCity = UserDefaultsHelper.getData(type: [String].self, forKey: .recentCity) ?? []
        if let index = recenCity.firstIndex(of: recent) {
            recenCity.remove(at: index)
        }
        recenCity.insert(recent, at: 0)
        if recenCity.count > 10 {
            recenCity.removeLast()
        }
        UserDefaultsHelper.setData(value: recenCity, key: .recentCity)
    }
}
