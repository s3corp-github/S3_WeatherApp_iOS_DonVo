//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

protocol CityListProtocol {
    var didGetCityList: ((CityList) -> Void)? { get set }
    var didFailWithError: ((APIError) -> Void)? { get set }

    func getCityList(with service: SearchService)
}

protocol RecentCityProtocol {
    func getRecentCity() -> [String]
    func updateRecentCity(recent: String, recentList: [String])
}

typealias SearchViewModelProtocol = CityListProtocol & RecentCityProtocol

struct SearchViewModel: SearchViewModelProtocol {
    private let userDefaults = UserDefaults.standard

    var didGetCityList: ((CityList) -> Void)?
    var didFailWithError: ((APIError) -> Void)?

    func getCityList(with service: SearchService) {
        Network.shared().request(with: service.url) { (result: (Result<CityData,APIError>)) in
            switch result {
            case .success(let data):
                let result = data.searchApi.result
                let cityList = CityList(result: result, matchPattern: service.pattern)
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
