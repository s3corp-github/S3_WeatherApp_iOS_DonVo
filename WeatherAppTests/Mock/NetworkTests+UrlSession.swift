//
//  NetworkTests+UrlSession.swift
//  WeatherAppTests
//
//  Created by don.vo on 1/5/23.
//

import Foundation

extension NetworkTests {
    class SessionMock: URLSession {
        private let data: Data?
        private let response: URLResponse?
        private let error: Error?

        init(data: Data? = nil,
             response: URLResponse? = nil,
             error: Error? = nil) {
            self.data = data
            self.response = response
            self.error = error
        }

        override func dataTask(with _: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let data = self.data
            let response = self.response
            let error = self.error
            return SessionDataTaskMock {
                completionHandler(data, response, error)
            }
        }

        override func dataTask(with _: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let data = self.data
            let response = self.response
            let error = self.error
            return SessionDataTaskMock {
                completionHandler(data, response, error)
            }
        }
    }

    class SessionDataTaskMock: URLSessionDataTask {
        private let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            closure()
        }

        override func cancel() {
            closure()
        }
    }
}
