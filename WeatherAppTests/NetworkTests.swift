//
//  NetworkTests.swift
//  WeatherAppTests
//
//  Created by Vo Minh Don on 1/2/23.
//

import XCTest
@testable import WeatherApp

final class NetworkTests: XCTestCase {

    private var promise: XCTestExpectation!

    struct EndointMock: Endpoint {
        var httpMethods: WeatherApp.HTTPMethod
        var params: WeatherApp.Parameters? = [:]
        var baseUrl: String = "https://httpstat.us/"
        var path: String
        var headers: [String : Any]? = [:]
        var body: [String : Any]? = [:]
    }

    override func setUpWithError() throws {
        try! super.setUpWithError()
    }

    override func tearDownWithError() throws {
        promise = nil
        try! super.tearDownWithError()
    }

    func test_whenMockDataPassed_thenReturnProperData() {
        // given
        promise = XCTestExpectation(description: "Get data")
        let mock = EndointMock(httpMethods: .get, baseUrl: "https://63b2dd285e490925c5242ac1.mockapi.io/", path: "mock/network")
        let expectedData = "200OK"

        // when
        Network.shared().request(with: mock) { [weak self] (result: (Result<[String], APIError>)) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.first ?? "", expectedData)
                self?.promise.fulfill()
            case .failure(_):
                XCTFail("got an error")
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockDataPassedAndWrongTypeDecode_thenReturnErrorDecodedData() {
        // given
        promise = XCTestExpectation(description: "Get error decoded error")
        let mock = EndointMock(httpMethods: .get, baseUrl: "https://63b2dd285e490925c5242ac1.mockapi.io/", path: "mock/network")

        // when
        Network.shared().request(with: mock) { [weak self] (result: (Result<String, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return error decoded data")
            case .failure(let error):
                XCTAssertEqual(error, .errorDecodedData)
                self?.promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenStatusCodeEqualOrAbove500_thenReturnServerError() {
        // given
        promise = XCTestExpectation(description: "Get server error")
        let mock = EndointMock(httpMethods: .get, path: "503")

        // when
        Network.shared().request(with: mock) { [weak self] (result: (Result<String, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return server error")
            case .failure(let error):
                if case APIError.errorRequestWithCode(let code, _) = error {
                    XCTAssertEqual(503, code)
                    self?.promise.fulfill()
                }
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenStatusCodeEqualOrAbove400_thenReturnClientError() {
        // given
        promise = XCTestExpectation(description: "Get client error")
        let mock = EndointMock(httpMethods: .get, path: "404")

        // when
        Network.shared().request(with: mock) { [weak self] (result: (Result<String, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return client error")
            case .failure(let error):
                if case APIError.errorRequestWithCode(let code, _) = error {
                    XCTAssertEqual(404, code)
                    self?.promise.fulfill()
                }
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockUrlStringPassed_thenReturnProperData() {
        // given
        promise = XCTestExpectation(description: "Get data")
        let urlString = "https://63b2dd285e490925c5242ac1.mockapi.io/mock/network"

        // when
        Network.shared().request(with: urlString) { [weak self] result in
            switch result {
            case .success(_):
                self?.promise.fulfill()
            case .failure(_):
                XCTFail("got an error")
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockUrlStringPassed_thenReturnError() {
        // given
        promise = XCTestExpectation(description: "Get data")
        let urlString = "httpstat.us/404"

        // when
        Network.shared().request(with: urlString) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail("should return error")
            case .failure(_):
                self?.promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }
}
