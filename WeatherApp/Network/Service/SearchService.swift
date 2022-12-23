//
//  SearchService.swift
//  WeatherApp
//
//  Created by don.vo on 12/21/22.
//

import Foundation

class SearchService {
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
}
