//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by don.vo on 11/29/22.
//

import XCTest
@testable import WeatherApp

final class CityViewModelTests: XCTestCase {

    private var cityVM: CityViewModel!
    private var weatherResult: Weather!
    private var error: APIError!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        cityVM = CityViewModel()
    }

    override func tearDownWithError() throws {
        cityVM = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    func testGetCityData() throws {
        //given
        getDataPromise = expectation(description: "get weather data")
        cityVM.delegate = self
        let city = "Ho Chi Minh"

        //when
        cityVM.fetchWeather(at: city)
        wait(for: [getDataPromise], timeout: 2)

        //then
        XCTAssertTrue(weatherResult.name.lowercased().contains(city.lowercased()))
    }

    func testGetCityDataWithWrongMatchingPattern() throws {
        //given
        errorPromise = expectation(description: "get error not matching")
        cityVM.delegate = self
        let city = "asdasd"

        //when
        cityVM.fetchWeather(at: city)
        wait(for: [errorPromise], timeout: 2)

        //then
        XCTAssertEqual(error, .error("Unable to find any matching weather location to the query submitted!"))
    }
}

extension CityViewModelTests: CityViewModelDelegate {
    func didUpdateWeatherCondition(_ model: WeatherApp.CityViewModel, weatherModel: WeatherApp.Weather) {
        weatherResult = weatherModel
        getDataPromise.fulfill()
    }

    func didFailWithError(_ model: WeatherApp.CityViewModel, error: WeatherApp.APIError) {
        self.error = error
        errorPromise.fulfill()
    }
}
