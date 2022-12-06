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
    private var searchResult: CityList!
    private var error: APIError!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        searchVM = SearchViewModel()
        searchVM.delegate = self
    }

    override func tearDownWithError() throws {
        searchVM = nil
        searchResult = nil
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
        searchVM.fetchCity(with: pattern)
        wait(for: [getDataPromise], timeout: 2)

        //then
        for val in searchResult.cityList {
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
        searchVM.fetchCity(with: pattern)
        wait(for: [errorPromise], timeout: 2)

        //then
        XCTAssertEqual(error, .error("Unable to find any matching weather location to the query submitted!"))
    }
}

extension SearchViewModelTest: SearchViewModelDelegate {
    func didUpdateCityList(_ model: WeatherApp.SearchViewModel, cityList: WeatherApp.CityList) {
        searchResult = cityList
        getDataPromise.fulfill()
    }

    func didFailWithError(_ model: WeatherApp.SearchViewModel, error: WeatherApp.APIError) {
        self.error = error
        errorPromise.fulfill()
    }
}
