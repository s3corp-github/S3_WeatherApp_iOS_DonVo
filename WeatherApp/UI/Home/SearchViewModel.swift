//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import Foundation

enum SearchCityError: Error {
    case emptyMatchingList
    case emptyRecentList

    var message: String {
        switch self {
        case .emptyMatchingList:
            return "Unable to find any matching weather location to the query submitted!"
        case .emptyRecentList:
            return "You don't have any search history yet!"
        }
    }
}

protocol CityListProtocol {
    func getCityList(with input: String)
}

protocol RecentCityProtocol {
    func getRecentCity()
    func updateRecentCity(recent: String)
}

protocol SearchViewModelProtocol: CityListProtocol, RecentCityProtocol {
    var cityList: [String] { get }
    var previousSearchPattern: String { get }
    var didGetCityList: (() -> Void)? { get set }
    var didFailWithError: ((Error) -> Void)? { get set }

    func fetchData(with input: String) -> Bool
}

class SearchViewModel: SearchViewModelProtocol {
    let searchService: SearchServiceProtocol

    var cityList: [String] = []
    var previousSearchPattern: String = ""
    var didGetCityList: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?

    init(service: SearchServiceProtocol = SearchService.init()) {
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
                    self?.cityList.removeAll()
                    self?.didFailWithError?(SearchCityError.emptyMatchingList)
                    return
                }
                self?.cityList = cityList
                self?.didGetCityList?()
            case .failure(let error):
                self?.cityList.removeAll()
                self?.didFailWithError?(error)
            }
        }
    }

    func getRecentCity() {
        let recenCity = searchService.getRecentCity()
        guard !recenCity.isEmpty else {
            cityList.removeAll()
            didFailWithError?(SearchCityError.emptyRecentList)
            return
        }
        cityList = recenCity
        didGetCityList?()
    }

    func updateRecentCity(recent: String) {
        searchService.updateRecentCity(recent: recent)
    }
}
