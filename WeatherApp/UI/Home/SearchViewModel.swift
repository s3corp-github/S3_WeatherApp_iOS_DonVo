//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func didUpdateCityList(_ model: SearchViewModel, cityList: CityList)
    func didFailWithError(_ model: SearchViewModel, error: APIError)
}

struct SearchViewModel {
    private let userDefaults = UserDefaults.standard
    weak var delegate: SearchViewModelDelegate?

    func fetchCity(with cityPattern: String) {
        let service: SearchService = .searchCity(cityPattern)
        getCityList(url: service.url)
    }

    private func getCityList(url: String) {
        Network.shared().request(with: url) { (result: (Result<CityData,APIError>)) in
            switch result {
            case .success(let data):
                let result = data.searchApi.result
                let cityList = CityList(result: result)
                delegate?.didUpdateCityList(self, cityList: cityList)
            case .failure(let error):
                delegate?.didFailWithError(self, error: error)
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
