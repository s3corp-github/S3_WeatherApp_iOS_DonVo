//
//  SearchViewModelTest.swift
//  WeatherAppTests
//
//  Created by don.vo on 12/2/22.
//

import XCTest
@testable import WeatherApp

final class SearchViewModelTests: XCTestCase {

    private var error: Error!
    private var viewModel: SearchViewModel!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        viewModel = SearchViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        error = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    //MARK: - CityListProtocol
    func test_whenSearchServiceRetrievesCityListOfPattern_thenViewModelContainsCityListMatchPattern() throws {
        //given
        let pattern = "Lon"
        getDataPromise = expectation(description: "get city list of pattern")
        viewModel.didGetCityList = { [weak self] in
            self?.getDataPromise.fulfill()
        }
        viewModel.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        _ = viewModel.fetchData(with: pattern)
        wait(for: [getDataPromise], timeout: 3)
        let wrongCount = viewModel.cityList.filter { city in
            !city.lowercased().contains(pattern.lowercased())
        }.count

        //then
        XCTAssertEqual(wrongCount, 0)
    }

    func test_whenSearchServiceReturnsErrorNotFoundMatching_thenViewModelContainsError() throws {
        //given
        let pattern = "asdasd"
        errorPromise = expectation(description: "get error not found")
        viewModel.didGetCityList = {
            XCTFail("Expect to found an error but success instead")
        }
        viewModel.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        _ = viewModel.fetchData(with: pattern)
        wait(for: [errorPromise], timeout: 3)
        guard let apiError = error as? APIError else {
            XCTFail("Wrong Error type")
            return
        }

        //then
        XCTAssertEqual(apiError, .error("Unable to find any matching weather location to the query submitted!"))
    }

    func test_whenSearchServiceRetrievesCityListOfPattern_thenViewModelContainsErrorNotFoundMatching() throws {
        //given
        let pattern = "Roz"
        errorPromise = expectation(description: "get error not found")
        viewModel.didGetCityList = {
            XCTFail("Expect to found an error but get data instead")
        }
        viewModel.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        _ = viewModel.fetchData(with: pattern)
        wait(for: [errorPromise], timeout: 2)
        guard let apiError = error as? SearchCityError else {
            XCTFail("Wrong Error type")
            return
        }

        //then
        XCTAssertEqual(apiError.message, SearchCityError.emptyMatchingList.message)
    }

    func test_whenPatternMatchPreviousPatern_thenViewModelReturns() throws {
        //given
        let pattern = "Lon Don"
        viewModel.previousSearchPattern = "Lon Don"
        viewModel.didGetCityList = {
            XCTFail("Got data")
        }
        viewModel.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        let isFetched = viewModel.fetchData(with: pattern)

        //then
        XCTAssertEqual(isFetched, false)
    }

    //MARK: - RecentCityProtocol
    func test_whenSearchServiceRetrievesSavedRecentCities_thenViewModelContainsRecentCities() throws {
        //given
        getDataPromise = expectation(description: "get recent city")
        viewModel.didGetCityList = { [weak self] in
            self?.getDataPromise.fulfill()
        }
        viewModel.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        UserDefaultsHelper.clearAll()
        viewModel.previousSearchPattern = " "
        viewModel.updateRecentCity(recent: "Canada")
        viewModel.updateRecentCity(recent: "Singapore")
        viewModel.updateRecentCity(recent: "Ho Chi Minh")
        _ = viewModel.fetchData(with: "")
        wait(for: [getDataPromise], timeout: 3)

        //then
        XCTAssertEqual(viewModel.cityList, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func test_whenSearchServiceRetrievesEmptyRecentCities_thenViewModelContainsErrorEmpty() throws {
        //given
        errorPromise = expectation(description: "get error empty recent list")
        viewModel.didGetCityList = {
            XCTFail("Expect to found an error but get data instead")
        }
        viewModel.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        viewModel.previousSearchPattern = " "
        _ = viewModel.fetchData(with: "")
        wait(for: [errorPromise], timeout: 3)
        guard let apiError = error as? SearchCityError else {
            XCTFail("Wrong Error type")
            return
        }

        //then
        XCTAssertEqual(apiError.message, SearchCityError.emptyRecentList.message)
    }
}
