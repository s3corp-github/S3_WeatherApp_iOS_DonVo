//
//  SearchViewModelTest.swift
//  WeatherAppTests
//
//  Created by don.vo on 12/2/22.
//

import XCTest
@testable import WeatherApp

final class SearchViewModelTest: XCTestCase {

    private var searchVM: SearchViewModel!
    private var list: [String]!
    private var error: APIError!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        searchVM = SearchViewModel()
        list = []
    }

    override func tearDownWithError() throws {
        searchVM = nil
        list = nil
        error = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    func testGetCityListData() throws {
        //given
        getDataPromise = expectation(description: "get city data")
        let pattern = "Lon"
        var wrongCount = 0

        //when
        searchVM.didGetCityListFromAPI = { [weak self] list in
            self?.list = list
            self?.getDataPromise.fulfill()
        }
        searchVM.didFailWithError = { _ in
            XCTFail("Got an error")
        }
        searchVM.getCityList(with: pattern)
        wait(for: [getDataPromise], timeout: 2)

        //then
        for val in list {
            if !val.lowercased().contains(pattern.lowercased()) {
                wrongCount += 1
            }
        }
        XCTAssertEqual(wrongCount, 0)
    }

    func testGetCityListDataWithWrongPattern() throws {
        //given
        errorPromise = expectation(description: "get error not found")
        let pattern = "asdasd"

        //when
        searchVM.didGetCityListFromAPI = { _ in
            XCTFail("Expect to found an error but success instead")
        }
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }
        searchVM.getCityList(with: pattern)
        wait(for: [errorPromise], timeout: 2)

        //then
        XCTAssertEqual(error, .error("Unable to find any matching weather location to the query submitted!"))
    }

    func testGetCityListInUserDefault() throws {
        //given
        getDataPromise = expectation(description: "get recent city")
        list = []

        //when
        searchVM.didGetRecentCityList = { [weak self] list in
            self?.list = list
            self?.getDataPromise.fulfill()
        }
        searchVM.updateRecentCity(recent: "Canada")
        searchVM.updateRecentCity(recent: "Singapore")
        searchVM.updateRecentCity(recent: "Ho Chi Minh")
        searchVM.getRecentCity()
        wait(for: [getDataPromise], timeout: 1)

        //then
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func testGetCityListInUserDefaultWithMoreThanTenItems() throws {
        //given
        getDataPromise = expectation(description: "get recent city with ten more items")
        list = []

        //when
        searchVM.didGetRecentCityList = { [weak self] list in
            self?.list = list
            self?.getDataPromise.fulfill()
        }
        searchVM.updateRecentCity(recent: "Osaka")
        searchVM.updateRecentCity(recent: "Seoul")
        searchVM.updateRecentCity(recent: "Tokyo")
        searchVM.updateRecentCity(recent: "Texas")
        searchVM.updateRecentCity(recent: "New York")
        searchVM.updateRecentCity(recent: "Bangkok")
        searchVM.updateRecentCity(recent: "Hanoi")
        searchVM.updateRecentCity(recent: "Paris")
        searchVM.updateRecentCity(recent: "Canada")
        searchVM.updateRecentCity(recent: "Singapore")
        searchVM.updateRecentCity(recent: "Ho Chi Minh")
        searchVM.getRecentCity()
        wait(for: [getDataPromise], timeout: 1)

        //then
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada", "Paris", "Hanoi", "Bangkok", "New York", "Texas", "Tokyo", "Seoul"])
    }
}
