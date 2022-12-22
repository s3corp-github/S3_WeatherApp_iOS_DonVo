//
//  NetworkTests.swift
//  WeatherAppTests
//
//  Created by don.vo on 12/6/22.
//

import XCTest
@testable import WeatherApp

final class NetworkTests: XCTestCase {

    var error: APIError!
    var network: Network!
    var endpoint: Endpoint!
    private var errorPromise: XCTestExpectation!

    override func setUpWithError() throws {
        try! super.setUpWithError()
        network = Network.shared()
    }

    override func tearDownWithError() throws {
        network = nil
        error = nil
        errorPromise = nil
        endpoint = nil
        try! super.tearDownWithError()
    }

//    func testAPIErrorKeyIsInvalid() throws {
//        //given
//        endpoint = WeatherEndpoint.getWeather(city: "London")
//        endpoint.baseUrl = "https://api.worldweatheronline.com/"
//        endpoint.path = "premium/v1/weather.ashx?q=&key=&format=json"
//        errorPromise = expectation(description: "Status code 400")
//
//        //when
//        network.request(with: endpoint.url) { (result: (Result<BaseResponse<WeatherData>, APIError>)) in
//            switch result {
//            case .success(_):
//                XCTFail("Expect to find an error but success instead")
//            case .failure(let error):
//                self.error = error
//                self.errorPromise.fulfill()
//            }
//        }
//        wait(for: [errorPromise], timeout: 2)
//
//        //then
//        XCTAssertEqual(error, .errorRequestWithCode(400, "Parameter key is missing from the request URL"))
//    }
//
//    func testAPIErrorKeyIsMissing() throws {
//        //given
//        url = "https://api.worldweatheronline.com/premium/v1/weather.ashx?q=&key=abc&format=json"
//        errorPromise = expectation(description: "Status code 401")
//
//        //when
//        network.request(with: url) { (result: (Result<BaseResponse<WeatherData>, APIError>)) in
//            switch result {
//            case .success(_):
//                XCTFail("Expect to find an error but success instead")
//            case .failure(let error):
//                self.error = error
//                self.errorPromise.fulfill()
//            }
//        }
//        wait(for: [errorPromise], timeout: 2)
//
//        //then
//        XCTAssertEqual(error, .errorRequestWithCode(401, "API key is invalid."))
//    }
}
