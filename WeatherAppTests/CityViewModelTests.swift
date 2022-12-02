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
    private var promise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        cityVM = CityViewModel()
        weatherResult = Weather(tempC: "", description: [], weatherIconUrl: [], humidity: "")
    }

    override func tearDownWithError() throws {
        cityVM = nil
        try! super.tearDownWithError()
    }

    func testGetCityData() throws {
        //given
        promise = expectation(description: "get weather data")
        cityVM.delegate = self

        //when
        cityVM.fetchWeather(at: "Ho Chi Minh City")
        wait(for: [promise], timeout: 2)

        //then
        XCTAssertNotEqual(self.weatherResult.weatherIconUrlString, "")
        XCTAssertNotEqual(self.weatherResult.descriptionString, "")
        XCTAssertNotEqual(self.weatherResult.tempCString, "")
        XCTAssertNotEqual(self.weatherResult.humidity, "")
    }
}

extension CityViewModelTests: CityViewModelDelegate {
    func didUpdateWeatherCondition(_ model: WeatherApp.CityViewModel, weatherModel: WeatherApp.Weather) {
        weatherResult = weatherModel
        promise.fulfill()
    }

    func didFailWithError(_ model: WeatherApp.CityViewModel, error: WeatherApp.APIError) {
        XCTFail("Error: \(error.localizedDescription)")
    }
}
