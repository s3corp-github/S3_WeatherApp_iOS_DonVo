//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by don.vo on 11/29/22.
//

import XCTest
@testable import WeatherApp

final class CityViewModelTests: XCTestCase {

    func test_whenWeatherServiceRetrievesWeatherDataOfCity_thenViewModelContainsDataOfThatCity() throws {
        //given
        let viewModel = CityViewModel()
        let city = "Ho Chi Minh"
        let getDataPromise = expectation(description: "get weather data with pattern")
        viewModel.didGetWeather = { weather in
            let name = weather.name ?? ""
            let humidity = weather.humidity ?? ""
            let tempC = weather.tempC ?? ""
            XCTAssertTrue(name.lowercased().contains(city.lowercased()))
            XCTAssertNotEqual(weather.description, "")
            XCTAssertNotEqual(weather.humidity, "")
            XCTAssertTrue(humidity.contains(" g/m³"))
            XCTAssertNotEqual(weather.iconUrl, "")
            XCTAssertNotEqual(weather.tempC, "")
            XCTAssertTrue(tempC.contains("°C"))
            getDataPromise.fulfill()
        }
        viewModel.didFailWithError = { _ in
            XCTFail("Got an error")
        }

        //when
        viewModel.getWeatherDetail(city: city)

        //then
        wait(for: [getDataPromise], timeout: 3)
    }

    func test_whenWeatherServiceReturnsError_thenViewModelContainsError() throws {
        //given
        let viewModel = CityViewModel()
        let city = "asdasd"
        let errorPromise = expectation(description: "contains error")
        viewModel.didGetWeather = { _ in
            XCTFail("expect to contain error but retrieve data instead")
        }
        viewModel.didFailWithError = { error in
            XCTAssertEqual(error, .error("Unable to find any matching weather location to the query submitted!"))
            errorPromise.fulfill()
        }

        //when
        viewModel.getWeatherDetail(city: city)

        //then
        wait(for: [errorPromise], timeout: 3)
    }
}
