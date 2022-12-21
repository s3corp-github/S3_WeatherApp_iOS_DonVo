//
//  SearchService.swift
//  WeatherApp
//
//  Created by don.vo on 12/21/22.
//

import Foundation

class SearchService {
    func getCityList(pattern: String, completion: @escaping (Result<[String], APIError>) -> Void ) {
        let getCityListEndpoint = SearchEndpoint.getCityList(pattern: pattern)
        Network.shared().request(with: getCityListEndpoint) { (result: (Result<CityData, APIError>)) in
            switch result {
            case .success(let data):
                let result = data.searchApi.result
                let list = CityList(result: result, matchPattern: pattern)
                completion(.success(list.cityList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
