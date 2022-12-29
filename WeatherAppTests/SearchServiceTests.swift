//
//  SearchServiceTests.swift
//  WeatherAppTests
//
//  Created by don.vo on 12/29/22.
//

import XCTest
@testable import WeatherApp

class SearchServiceTests: XCTestCase {

    private var error: Error!
    var service: SearchService!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        service = SearchService()
    }

    override func tearDownWithError() throws {
        service = nil
        error = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    func test_whenUserDefaultsRetrievesSavedRecentCities_thenContainsDistinctRecentCitiesItem() throws {
        //given
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
        let pattern = "London"
        var list: [String] = []
        getDataPromise = XCTestExpectation(description: "get city list")

        //when
        service.getCityList(pattern: pattern) { [weak self]  result in
            switch result {
            case .success(let data):
                list = data.cityList
                self?.getDataPromise.fulfill()
            case.failure(_):
                XCTFail("Get an error")
            }
        }
        wait(for: [getDataPromise], timeout: 3)

        //then
        XCTAssertEqual(list, service.cache[pattern]?.cityList)
    }

    func test_whenRetrievesCityListAlreadyCached_thenContainsCityList() {
        // given
        let group = DispatchGroup()
        let pattern = "London"
        var list: [String] = []
        var cachedList: [String] = []
        getDataPromise = XCTestExpectation(description: "get city list")
        getDataPromise.expectedFulfillmentCount = 2

        //when
        group.enter()
        service.getCityList(pattern: pattern) { [weak self] result in
            group.leave()
            switch result {
            case .success(let data):
                list = data.cityList
                self?.getDataPromise.fulfill()
            case.failure(_):
                XCTFail("Get an error")
            }
        }
        group.wait()
        service.getCityList(pattern: pattern) { [weak self] result in
            switch result {
            case .success(let data):
                cachedList = data.cityList
                self?.getDataPromise.fulfill()
            case.failure(_):
                XCTFail("Get an error")
            }
        }
        wait(for: [getDataPromise], timeout: 4)

        //then
        XCTAssertEqual(list, cachedList)
    }
}
