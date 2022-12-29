//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by don.vo on 11/29/22.
//

import XCTest
@testable import WeatherApp

final class CityViewModelTests: XCTestCase {

    private var error: APIError!
    private var viewModel: CityViewModel!
    private var weatherResult: WeatherDataType!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        viewModel = CityViewModel()
    }

    override func tearDownWithError() throws {
        error = nil
        viewModel = nil
        weatherResult = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    func test_whenWeatherServiceRetrievesWeatherDataOfCity_thenViewModelContainsDataOfThatCity() throws {
        //given
        let city = "Ho Chi Minh"
        getDataPromise = expectation(description: "get weather data with pattern")
        viewModel.didGetWeather = { [weak self] weather in
            self?.weatherResult = weather
            self?.getDataPromise.fulfill()
        }
        viewModel.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        viewModel.getWeatherDetail(city: city)
        wait(for: [getDataPromise], timeout: 3)

        //then
        XCTAssertTrue(weatherResult.name.lowercased().contains(city.lowercased()))
    }

    func test_whenWeatherServiceReturnsError_thenViewModelContainsError() throws {
        //given
        let city = "asdasd"
        errorPromise = expectation(description: "contains error")
        viewModel.didGetWeather = { _ in
            XCTFail("expect to contain error but retrieve data instead")
        }
        viewModel.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        viewModel.getWeatherDetail(city: city)
        wait(for: [errorPromise], timeout: 3)

        //then
        XCTAssertEqual(error, .error("Unable to find any matching weather location to the query submitted!"))
    }
}
