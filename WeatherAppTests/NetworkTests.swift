//
//  NetworkTests.swift
//  WeatherAppTests
//
//  Created by Vo Minh Don on 1/2/23.
//

import XCTest
@testable import WeatherApp

final class NetworkTests: XCTestCase {

    func test_whenMockDataPassed_thenReturnProperData() {
        // given
        let promise = XCTestExpectation(description: "Get data")
        let mock = EndointMock(httpMethods: .get, path: "/200")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.code , 200)
                XCTAssertEqual(data.description , "OK")
                promise.fulfill()
            case .failure(_):
                XCTFail("got an error")
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockDataPassedAndWrongTypeDecode_thenReturnErrorDecodedData() {
        // given
        let promise = XCTestExpectation(description: "Get error decoded error")
        let mock = EndointMock(httpMethods: .get, path: "/200")

        // when
        Network.shared().request(with: mock) { (result: (Result<String, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return error decoded data")
            case .failure(let error):
                XCTAssertEqual(error, .errorDecodedData)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenStatusCodeEqualOrAbove400_thenReturnClientError() {
        // given
        let promise = XCTestExpectation(description: "Get client error")
        let mock = EndointMock(httpMethods: .get, path: "/404")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return client error")
            case .failure(let error):
                if case APIError.errorRequestWithCode(let code, _) = error {
                    XCTAssertEqual(404, code)
                    promise.fulfill()
                }
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenStatusCodeEqualOrAbove500_thenReturnServerError() {
        // given
        let promise = XCTestExpectation(description: "Get server error")
        let mock = EndointMock(httpMethods: .get, path: "/503")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return server error")
            case .failure(let error):
                if case APIError.errorRequestWithCode(let code, _) = error {
                    XCTAssertEqual(503, code)
                    promise.fulfill()
                }
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenStatusCodeAbove599_thenReturnUnknownError() {
        // given
        let promise = XCTestExpectation(description: "Get unknown error")
        let mock = EndointMock(httpMethods: .get, path: "/600")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return unknown error")
            case .failure(let error):
                XCTAssertEqual(error, .errorUnknown)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockDataUnsupportedBaseUrlPassed_thenReturnError() {
        // given
        let promise = XCTestExpectation(description: "Get unsupported url error")
        let mock = EndointMock(httpMethods: .get, baseUrl: "123" , path: "/404")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return unsuported error")
            case .failure(let error):
                XCTAssertEqual(error, .error("unsupported URL"))
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockDataMalformedBaseUrlPassed_thenReturnErrorMalfomedUrl() {
        // given
        let promise = XCTestExpectation(description: "Get malformed error")
        let mock = EndointMock(httpMethods: .get, baseUrl: "https://httpstat.us:-80" , path: "/404")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return malformed error")
            case .failure(let error):
                XCTAssertEqual(error, .errorMalformedURL)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockDataInValidUrlPassed_thenReturnErrorUrl() {
        // given
        let promise = XCTestExpectation(description: "Get url error")
        let mock = EndointMock(httpMethods: .get, path: "200")

        // when
        Network.shared().request(with: mock) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return url error")
            case .failure(let error):
                XCTAssertEqual(error, .errorURL)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockNilResponsePassed_thenReturnErrorCanNotGetResponse() {
        // given
        let promise = XCTestExpectation(description: "Get response error")
        let mock = EndointMock(httpMethods: .get, path: "/200")
        let session = SessionMock(data: Data(), response: nil)

        // when
        Network.shared().request(with: mock, session: session) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return response error")
            case .failure(let error):
                XCTAssertEqual(error, .error("Can not get http response"))
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockNilDataPassed_thenReturnErrorDataNotExist() {
        // given
        let promise = XCTestExpectation(description: "Get data error")
        let mock = EndointMock(httpMethods: .get, path: "/200")
        let mockResponse = HTTPURLResponse()
        let session = SessionMock(data: nil, response: mockResponse)

        // when
        Network.shared().request(with: mock, session: session) { (result: (Result<responseMock, APIError>)) in
            switch result {
            case .success(_):
                XCTFail("Should return data not exist error")
            case .failure(let error):
                XCTAssertEqual(error, .errorDataNotExist)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockUrlStringPassed_thenReturnProperData() {
        // given
        let promise = XCTestExpectation(description: "Get data")
        let urlString = "https://httpstat.us/200"

        // when
        Network.shared().request(with: urlString) { result in
            switch result {
            case .success(_):
                promise.fulfill()
            case .failure(_):
                XCTFail("got an error")
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenMockUrlStringPassed_thenReturnError() {
        // given
        let promise = XCTestExpectation(description: "Get data")
        let urlString = "httpstat.us/404"

        // when
        Network.shared().request(with: urlString) { result in
            switch result {
            case .success(_):
                XCTFail("should return error")
            case .failure(_):
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenEmptyUrlStringPassed_thenReturnError() {
        // given
        let promise = XCTestExpectation(description: "Get error")
        let urlString = ""

        // when
        Network.shared().request(with: urlString) { result in
            switch result {
            case .success(_):
                XCTFail("should return error")
            case .failure(let error):
                XCTAssertEqual(error, .errorURL)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenUrlStringAndNilDataPassed_thenReturnErrorDataNotExist() {
        // given
        let promise = XCTestExpectation(description: "Get error")
        let urlString = "https://httpstat.us/200"
        let sessionMock = SessionMock()

        // when
        Network.shared().request(with: urlString, session: sessionMock) { result in
            switch result {
            case .success(_):
                XCTFail("should return error")
            case .failure(let error):
                XCTAssertEqual(error, .errorDataNotExist)
                promise.fulfill()
            }
        }

        //then
        wait(for: [promise], timeout: 2)
    }

    func test_whenAPIErrorUsed_thenReturnCorrectErrorDescription() {
        //given
        let error = APIError.error("Example Error")
        let errorMalformedURL = APIError.errorMalformedURL
        let errorURL = APIError.errorURL
        let errorUnknown = APIError.errorUnknown
        let errorDataNotExist = APIError.errorDataNotExist
        let errorDecodedData = APIError.errorDecodedData
        let errorRequestWithCode = APIError.errorRequestWithCode(404, "Not Found")
        let errorRequestWithCodeAndNilDescription = APIError.errorRequestWithCode(404, nil)

        //when
        //then
        XCTAssertEqual(error.localizedDescription, "Example Error")
        XCTAssertEqual(errorMalformedURL.localizedDescription, "URL String is malformed.")
        XCTAssertEqual(errorURL.localizedDescription, "URL String is error.")
        XCTAssertEqual(errorUnknown.localizedDescription, "Unknown error")
        XCTAssertEqual(errorDataNotExist.localizedDescription, "Data is not exist.")
        XCTAssertEqual(errorDecodedData.localizedDescription, "Can not decode data.")
        XCTAssertEqual(errorRequestWithCode.localizedDescription, "Error 404: Not Found")
        XCTAssertEqual(errorRequestWithCodeAndNilDescription.localizedDescription, "Error 404: ")
    }
}
