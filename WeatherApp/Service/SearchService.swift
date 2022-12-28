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

class SearchService: SearchServiceProtocol {
    private let cache: CacheHelper<String, CityDataType>

    init(cache: CacheHelper<String, CityDataType> = .init(cost: 50_000_000)) {
        self.cache = cache
    }

    func getCityList(pattern: String, completion: @escaping (Result<CityDataType, APIError>) -> Void ) {
        if let cached = cache[pattern] {
            completion(.success(cached))
            return
        }

        let getCityListEndpoint = SearchEndpoint.getCityList(pattern: pattern)
        Network.shared().request(with: getCityListEndpoint) { [weak self] (result: (Result<CityData, APIError>)) in
            switch result {
            case .success(let data):
                self?.cache[pattern] = data
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
