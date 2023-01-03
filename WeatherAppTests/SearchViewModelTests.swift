//
//  SearchViewModelTest.swift
//  WeatherAppTests
//
//  Created by don.vo on 12/2/22.
//

import XCTest
@testable import WeatherApp

final class SearchViewModelTests: XCTestCase {

    //MARK: - CityListProtocol
    func test_whenSearchServiceRetrievesCityListOfPattern_thenViewModelContainsCityListMatchPattern() throws {
        //given
        let viewModel = SearchViewModel()
        let pattern = "Lon"
        let getDataPromise = expectation(description: "get city list of pattern")
        viewModel.didGetCityList = {
            getDataPromise.fulfill()
        }
        viewModel.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        viewModel.fetchData(with: pattern)
        wait(for: [getDataPromise], timeout: 3)
        let wrongCount = viewModel.cityList.filter { city in
            !city.lowercased().contains(pattern.lowercased())
        }.count

        //then
        XCTAssertEqual(wrongCount, 0)
    }

    func test_whenSearchServiceReturnsErrorNotFoundMatching_thenViewModelContainsError() throws {
        //given
        let viewModel = SearchViewModel()
        let pattern = "asdasd"
        let errorPromise = expectation(description: "get error not found")
        viewModel.didGetCityList = {
            XCTFail("Expect to found an error but success instead")
        }
        viewModel.didFailWithError = {  error in
            guard let apiError = error as? APIError else {
                XCTFail("Wrong Error type")
                return
            }
            XCTAssertEqual(apiError, .error("Unable to find any matching weather location to the query submitted!"))
            errorPromise.fulfill()
        }

        //when
        viewModel.fetchData(with: pattern)

        //then
        wait(for: [errorPromise], timeout: 3)
    }

    func test_whenSearchServiceRetrievesCityListOfPattern_thenViewModelContainsErrorNotFoundMatching() throws {
        //given
        let viewModel = SearchViewModel()
        let pattern = "Roz"
        let errorPromise = expectation(description: "get error not found")
        viewModel.didGetCityList = {
            XCTFail("Expect to found an error but get data instead")
        }
        viewModel.didFailWithError = { error in
            guard let apiError = error as? SearchCityError else {
                XCTFail("Wrong Error type")
                return
            }
            XCTAssertEqual(apiError.message, SearchCityError.emptyMatchingList.message)
            errorPromise.fulfill()
        }

        //when
        viewModel.fetchData(with: pattern)

        //then
        wait(for: [errorPromise], timeout: 2)
    }

    func test_whenPatternMatchPreviousPattern_thenViewModelReturns() throws {
        //given
        let viewModel = SearchViewModel()
        let pattern = "Lon Don"
        viewModel.previousSearchPattern = "Lon Don"

        //when
        let isFetched = viewModel.willFetchData(with: pattern)

        //then
        XCTAssertEqual(isFetched, false)
    }

    //MARK: - RecentCityProtocol
    func test_whenSearchServiceRetrievesSavedRecentCities_thenViewModelContainsRecentCities() throws {
        //given
        let viewModel = SearchViewModel()
        let getDataPromise = expectation(description: "get recent city")
        viewModel.didGetCityList = {
            getDataPromise.fulfill()
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
        viewModel.fetchData(with: "")
        wait(for: [getDataPromise], timeout: 3)

        //then
        XCTAssertEqual(viewModel.cityList, ["Ho Chi Minh" ,"Singapore", "Canada"])
    }

    func test_whenSearchServiceRetrievesEmptyRecentCities_thenViewModelContainsErrorEmpty() throws {
        //given
        let viewModel = SearchViewModel()
        let errorPromise = expectation(description: "get error empty recent list")
        viewModel.didGetCityList = {
            XCTFail("Expect to found an error but get data instead")
        }
        viewModel.didFailWithError = { error in
            guard let apiError = error as? SearchCityError else {
                XCTFail("Wrong Error type")
                return
            }
            XCTAssertEqual(apiError.message, SearchCityError.emptyRecentList.message)
            errorPromise.fulfill()
        }

        //when
        UserDefaultsHelper.clearAll()
        viewModel.previousSearchPattern = " "
        viewModel.fetchData(with: "")

        //then
        wait(for: [errorPromise], timeout: 3)
    }
}
