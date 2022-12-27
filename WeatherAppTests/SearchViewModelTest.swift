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
    private var error: Error!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        searchVM = SearchViewModel(service: SearchService.init())
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
        let pattern = "Lon"
        var wrongCount = 0
        getDataPromise = expectation(description: "get city data")
        searchVM.didGetCityList = { [weak self] list in
            self?.list = list
            self?.getDataPromise.fulfill()
        }
        searchVM.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        _ = searchVM.fetchData(with: pattern)
        wait(for: [getDataPromise], timeout: 2)

        //then
        for val in list {
            if !val.lowercased().contains(pattern.lowercased()) {
                wrongCount += 1
            }
        }
        XCTAssertEqual(wrongCount, 0)
    }

    func testGetCityListDataWithPatternEqualPreviousPattern() throws {
        //given
        let pattern = "Lon Don"
        searchVM.previousSearchPattern = "Lon Don"
        searchVM.didGetCityList = { _ in
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
        errorPromise = expectation(description: "get error not found")
        let pattern = "asdasd"
        searchVM.didGetCityList = { _ in
            XCTFail("Expect to found an error but success instead")
        }
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        _ = searchVM.fetchData(with: pattern)
        wait(for: [errorPromise], timeout: 2)

        //then
        guard let apiError = error as? APIError else {
            XCTFail("Wrong Error type")
            return
        }
        errorMessage = apiError.localizedDescription
        XCTAssertEqual(errorMessage, "Unable to find any matching weather location to the query submitted!")
    }

    func testGetCityListDataWithPatternDontMatch() throws {
        //given
        var errorMessage = ""
        let pattern = "Roz"
        errorPromise = expectation(description: "get error not found")
        searchVM.didGetCityList = { _ in
            XCTFail("Expect to found an error but success instead")
        }
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        _ = searchVM.fetchData(with: pattern)
        wait(for: [errorPromise], timeout: 2)

        //then
        guard let apiError = error as? SearchCityError else {
            XCTFail("Wrong Error type")
            return
        }
        errorMessage = apiError.message
        XCTAssertEqual(errorMessage, "Unable to find any matching weather location to the query submitted!")
    }

    func testGetCityListInUserDefault() throws {
        //given
        getDataPromise = expectation(description: "get recent city")
        list = []
        searchVM.didGetCityList = { [weak self] list in
            self?.list = list
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
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func testGetCityListInUserDefaultWithEmptyData() throws {
        //given
        errorPromise = expectation(description: "get error empty recent list")
        list = []
        searchVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        searchVM.previousSearchPattern = "a"
        _ = searchVM.fetchData(with: "")
        wait(for: [errorPromise], timeout: 1)

        //then
        guard let apiError = error as? SearchCityError else {
            XCTFail("Wrong Error type")
            return
        }
        XCTAssertEqual(apiError, SearchCityError.emptyRecentList)
    }

    func testGetCityListInUserDefaultWithDuplicatedItem() throws {
        //given
        getDataPromise = expectation(description: "get recent city")
        list = []
        searchVM.didGetCityList = { [weak self] list in
            self?.list = list
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
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func testGetCityListInUserDefaultWithMoreThanTenItems() throws {
        //given
        getDataPromise = expectation(description: "get recent city with ten more items")
        list = []
        searchVM.didGetCityList = { [weak self] list in
            self?.list = list
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
        XCTAssertEqual(list, ["Ho Chi Minh" ,"Singapore", "Canada", "Paris", "Hanoi", "Bangkok", "New York", "Texas", "Tokyo", "Seoul"])
    }
}
