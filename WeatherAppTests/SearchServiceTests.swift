//
//  SearchServiceTests.swift
//  WeatherAppTests
//
//  Created by don.vo on 12/29/22.
//

import XCTest
@testable import WeatherApp

final class SearchServiceTests: XCTestCase {

    struct CityDataMock: CityDataType {
        var cityList: [String]
    }

    func test_whenUserDefaultsRetrievesSavedRecentCities_thenContainsDistinctRecentCitiesItem() throws {
        //given
        let service = SearchService()
        var list: [String] = []

        //when
        UserDefaultsHelper.clearAll()
        service.updateRecentCity(recent: "Canada")
        service.updateRecentCity(recent: "Canada")
        service.updateRecentCity(recent: "Singapore")
        service.updateRecentCity(recent: "Ho Chi Minh")
        list = service.getRecentCity()

        //then
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func test_whenUserDefaultsRetrievesSavedRecentCities_thenContainsRecentCitiesWithMaximumTenItems() throws {
        //given
        let service = SearchService()
        var list: [String] = []

        //when
        UserDefaultsHelper.clearAll()
        service.updateRecentCity(recent: "Osaka")
        service.updateRecentCity(recent: "Seoul")
        service.updateRecentCity(recent: "Tokyo")
        service.updateRecentCity(recent: "Texas")
        service.updateRecentCity(recent: "New York")
        service.updateRecentCity(recent: "Bangkok")
        service.updateRecentCity(recent: "Hanoi")
        service.updateRecentCity(recent: "Paris")
        service.updateRecentCity(recent: "Canada")
        service.updateRecentCity(recent: "Singapore")
        service.updateRecentCity(recent: "Ho Chi Minh")
        list = service.getRecentCity()

        //then
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada", "Paris", "Hanoi", "Bangkok", "New York", "Texas", "Tokyo", "Seoul"])
    }

    func test_whenSuccessfullyGetCityListOfPattern_thenDataIsSavedInCache() {
        // given
        let service = SearchService()
        let pattern = "London"
        let getDataPromise = XCTestExpectation(description: "get city list")

        //when
        service.getCityList(pattern: pattern) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.cityList, service.cache[pattern]?.cityList)
                getDataPromise.fulfill()
            case.failure(_):
                XCTFail("Get an error")
            }
        }

        //then
        wait(for: [getDataPromise], timeout: 3)
    }

    func test_whenRetrievesCityListAlreadyCached_thenContainsCityList() {
        // given
        let service = SearchService()
        let pattern = "London"
        let cachedList: [String] = ["London", "LondonSecond", "LondonThird"]
        let mock = CityDataMock(cityList: cachedList)
        let getDataPromise = XCTestExpectation(description: "get city list")

        //when
        service.cache[pattern] = nil
        service.cache[pattern] = mock

        service.getCityList(pattern: pattern) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.cityList, cachedList)
                getDataPromise.fulfill()
            case.failure(_):
                XCTFail("Get an error")
            }
        }

        //then
        wait(for: [getDataPromise], timeout: 2)
    }
}
