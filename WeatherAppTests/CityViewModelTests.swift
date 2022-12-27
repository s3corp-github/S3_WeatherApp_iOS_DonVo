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
    private var weatherResult: WeatherDataType!
    private var error: APIError!
    private var getDataPromise: XCTestExpectation!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        cityVM = CityViewModel(service: WeatherService.init())
    }

    override func tearDownWithError() throws {
        cityVM = nil
        weatherResult = nil
        error = nil
        getDataPromise = nil
        errorPromise = nil
        try! super.tearDownWithError()
    }

    func testGetWeatherData() throws {
        //given
        getDataPromise = expectation(description: "get weather data")
        let city = "Ho Chi Minh"
        cityVM.didGetWeather = { [weak self] weather in
            self?.weatherResult = weather
            self?.getDataPromise.fulfill()
        }
        cityVM.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        cityVM.getWeatherDetail(city: city)
        wait(for: [getDataPromise], timeout: 2)

        //then
        XCTAssertTrue(weatherResult.name.lowercased().contains(city.lowercased()))
    }

    func testGetWeatherDataWithWrongPattern() throws {
        //given
        let city = "asdasd"
        errorPromise = expectation(description: "get error not found")
        cityVM.didGetWeather = { _ in
            XCTFail("Expect to found an error but success instead")
        }
        cityVM.didFailWithError = { [weak self] error in
            self?.error = error
            self?.errorPromise.fulfill()
        }

        //when
        cityVM.getWeatherDetail(city: city)
        wait(for: [errorPromise], timeout: 2)

        //then
        XCTAssertEqual(error, .error("Unable to find any matching weather location to the query submitted!"))
    }
}
