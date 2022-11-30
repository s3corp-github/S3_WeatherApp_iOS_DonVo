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
    private let baseUrl: String = "https://api.worldweatheronline.com/premium/v1/search.ashx?key=712fe930090e454885631934222911&format=json"
    private let userDefaults = UserDefaults.standard
    weak var delegate: SearchViewModelDelegate?

    func fetchCity(with cityPattern: String) {
        let url = "\(baseUrl)&q=\(cityPattern)"
        getCityList(url: url)
    }

    private func getCityList(url: String) {
        Network.shared().request(with: url) { result in
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
            let decodeData = try decoder.decode(CityData.self, from: data)
            let result = decodeData.searchApi.result
            let cityList = CityList(result: result)
            delegate?.didUpdateCityList(self, cityList: cityList)
        } catch {
            delegate?.didFailWithError(self, error: APIError.error("Can not decode data"))
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
