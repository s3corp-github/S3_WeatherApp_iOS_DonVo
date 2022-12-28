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
    private var error: Error!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        searchVM = SearchViewModel(service: SearchService.init())
    }

    override func tearDownWithError() throws {
        searchVM = nil
        error = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    func testGetCityListData() throws {
        //given
        let pattern = "Lon"
        var wrongCount = 0
        getDataPromise = expectation(description: "get city data")
        searchVM.didGetCityList = { [weak self] in
            self?.getDataPromise.fulfill()
        }
        searchVM.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        _ = searchVM.fetchData(with: pattern)
        wait(for: [getDataPromise], timeout: 2)
        for val in searchVM.cityList {
            if !val.lowercased().contains(pattern.lowercased()) {
                wrongCount += 1
            }
        }

        //then
        XCTAssertEqual(wrongCount, 0)
    }

    func testGetCityListDataWithPatternEqualPreviousPattern() throws {
        //given
        let pattern = "Lon Don"
        searchVM.previousSearchPattern = "Lon Don"
        searchVM.didGetCityList = {
            XCTFail("Got data")
        }
        searchVM.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        let result = searchVM.fetchData(with: pattern)

        //then
        XCTAssertEqual(result, false)
    }

    func testGetCityListDataWithWrongPattern() throws {
        //given
        var errorMessage = ""
        let pattern = "asdasd"
        errorPromise = expectation(description: "get error not found")
        searchVM.didGetCityList = {
            XCTFail("Expect to found an error but success instead")
        }
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        _ = searchVM.fetchData(with: pattern)
        wait(for: [errorPromise], timeout: 2)
        guard let apiError = error as? APIError else {
            XCTFail("Wrong Error type")
            return
        }
        errorMessage = apiError.localizedDescription

        //then
        XCTAssertEqual(errorMessage, "Unable to find any matching weather location to the query submitted!")
    }

    func testGetCityListDataWithPatternDontMatch() throws {
        //given
        var errorMessage = ""
        let pattern = "Roz"
        errorPromise = expectation(description: "get error not found")
        searchVM.didGetCityList = {
            XCTFail("Expect to found an error but success instead")
        }
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        _ = searchVM.fetchData(with: pattern)
        wait(for: [errorPromise], timeout: 2)
        guard let apiError = error as? SearchCityError else {
            XCTFail("Wrong Error type")
            return
        }
        errorMessage = apiError.message

        //then
        XCTAssertEqual(errorMessage, "Unable to find any matching weather location to the query submitted!")
    }

    func testGetCityListInUserDefault() throws {
        //given
        getDataPromise = expectation(description: "get recent city")
        searchVM.didGetCityList = { [weak self] in
            self?.getDataPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        searchVM.previousSearchPattern = " "
        searchVM.updateRecentCity(recent: "Canada")
        searchVM.updateRecentCity(recent: "Singapore")
        searchVM.updateRecentCity(recent: "Ho Chi Minh")
        _ = searchVM.fetchData(with: "")
        wait(for: [getDataPromise], timeout: 1)

        //then
        XCTAssertEqual(searchVM.cityList, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func testGetCityListInUserDefaultWithEmptyData() throws {
        //given
        errorPromise = expectation(description: "get error empty recent list")
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        searchVM.previousSearchPattern = "a"
        _ = searchVM.fetchData(with: "")
        wait(for: [errorPromise], timeout: 1)
        guard let apiError = error as? SearchCityError else {
            XCTFail("Wrong Error type")
            return
        }

        //then
        XCTAssertEqual(apiError, SearchCityError.emptyRecentList)
    }

    func testGetCityListInUserDefaultWithDuplicatedItem() throws {
        //given
        getDataPromise = expectation(description: "get recent city")
        searchVM.didGetCityList = { [weak self] in
            self?.getDataPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        searchVM.previousSearchPattern = " "
        searchVM.updateRecentCity(recent: "Canada")
        searchVM.updateRecentCity(recent: "Canada")
        searchVM.updateRecentCity(recent: "Singapore")
        searchVM.updateRecentCity(recent: "Ho Chi Minh")
        _ = searchVM.fetchData(with: "")
        wait(for: [getDataPromise], timeout: 1)

        //then
        XCTAssertEqual(searchVM.cityList, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func testGetCityListInUserDefaultWithMoreThanTenItems() throws {
        //given
        getDataPromise = expectation(description: "get recent city with ten more items")
        searchVM.didGetCityList = { [weak self]  in
            self?.getDataPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        searchVM.previousSearchPattern = " "
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
        _ = searchVM.fetchData(with: "")
        wait(for: [getDataPromise], timeout: 1)

        //then
        XCTAssertEqual(searchVM.cityList, ["Ho Chi Minh" ,"Singapore", "Canada", "Paris", "Hanoi", "Bangkok", "New York", "Texas", "Tokyo", "Seoul"])
    }
}
