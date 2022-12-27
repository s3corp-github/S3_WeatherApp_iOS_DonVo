//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

protocol CityListProtocol {
    func getCityList(with input: String)
}

protocol RecentCityProtocol {
    func getRecentCity()
    func updateRecentCity(recent: String)
}

protocol SearchViewModelProtocol: CityListProtocol, RecentCityProtocol {
    var cityList: [String] { get set }
    var previousSearchPattern: String { get set }
    var didGetCityList: (([String]) -> Void)? { get set }
    var didFailWithError: ((Error) -> Void)? { get set }

    func fetchData(with input: String) -> Bool
}

class SearchViewModel: SearchViewModelProtocol {
    let searchService: SearchServiceProtocol

    var cityList: [String] = []
    var previousSearchPattern: String = ""
    var didGetCityList: (([String]) -> Void)?
    var didFailWithError: ((Error) -> Void)?

    init(service: SearchServiceProtocol) {
        self.searchService = service
    }

    func fetchData(with input: String) -> Bool {
        let handleInput = input.handleWhiteSpace()
        guard handleInput != previousSearchPattern else { return false }
        previousSearchPattern = handleInput

        if handleInput == "" {
            getRecentCity()
        } else {
            getCityList(with: handleInput)
        }
        return true
    }

    func getCityList(with input: String) {
        searchService.getCityList(pattern: input) { [weak self] result in
            guard self?.previousSearchPattern == input else { return }
            switch result {
            case .success(let data):
                let cityList = data.getCityListMatchPattern(pattern: input)
                guard !cityList.isEmpty else {
                    self?.didFailWithError?(SearchCityError.emptyMatchingList)
                    return
                }
                self?.didGetCityList?(cityList)
            case .failure(let error):
                self?.didFailWithError?(error)
            }
        }
    }

    func getRecentCity() {
        let recenCity = searchService.getRecentCity()
        guard !recenCity.isEmpty else {
            didFailWithError?(SearchCityError.emptyRecentList)
            return
        }
        didGetCityList?(recenCity)
    }

    func updateRecentCity(recent: String) {
        searchService.updateRecentCity(recent: recent)
    }
}
