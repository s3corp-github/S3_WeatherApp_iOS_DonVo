//
//  SearchService.swift
//  WeatherApp
//
//  Created by don.vo on 12/21/22.
//

import Foundation

protocol SearchServiceProtocol {
    func getCityList(pattern: String, completion: @escaping (Result<CityDataType, APIError>) -> Void)
    func getRecentCity() -> [String]
    func updateRecentCity(recent: String)
}

struct SearchService: SearchServiceProtocol {
    func getCityList(pattern: String, completion: @escaping (Result<CityDataType, APIError>) -> Void ) {
        let getCityListEndpoint = SearchEndpoint.getCityList(pattern: pattern)
        Network.shared().request(with: getCityListEndpoint) { (result: (Result<CityData, APIError>)) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRecentCity() -> [String] {
        let recenCity = UserDefaultsHelper.getData(type: [String].self, forKey: .recentCity) ?? []
        return recenCity
    }

    func updateRecentCity(recent: String) {
        var recenCity = getRecentCity()
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
