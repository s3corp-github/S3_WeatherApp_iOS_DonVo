//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

struct SearchViewModel {
    private let userDefaults = UserDefaults.standard
    var didGetCityList: ((CityList) -> Void)?
    var didFailWithError: ((APIError) -> Void)?

    func fetchCity(with cityPattern: String) {
        let service: SearchService = .searchCity(cityPattern)
        getCityList(with: service.url, pattern: cityPattern)
    }

    private func getCityList(with url: String, pattern: String) {
        Network.shared().request(with: url) { (result: (Result<CityData,APIError>)) in
            switch result {
            case .success(let data):
                let result = data.searchApi.result
                let cityList = CityList(result: result, matchPattern: pattern)
                didGetCityList?(cityList)
            case .failure(let error):
                didFailWithError?(error)
            }
        }
    }

    func getRecentCity() -> [String] {
        let recenCity = userDefaults.object(forKey: "recentCity") as? [String] ?? []
        return recenCity
    }

    func updateRecentCity(recent: String, recentList: [String]) {
        var list = recentList
        if let index = list.firstIndex(of: recent) {
            list.remove(at: index)
        }
        list.insert(recent, at: 0)
        if list.count > 10 {
            list.removeLast()
        }
        userDefaults.set(list, forKey: "recentCity")
    }
}
