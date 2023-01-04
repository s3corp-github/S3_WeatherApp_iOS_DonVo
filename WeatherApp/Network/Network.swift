//
//  Networking.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

enum APIError: Error, Equatable {
    case error(String)
    case errorRequestWithCode(Int, String)
    case errorURL
    case errorMalformedURL
    case errorDataNotExist
    case errorDecodedData
    case errorUnknown

    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorRequestWithCode(let code, let message):
            return "Error \(code): \(message)"
        case .errorURL:
            return "URL String is error."
        case .errorMalformedURL:
            return "URL String is malformed."
        case .errorDataNotExist:
            return "Data is not exist."
        case .errorDecodedData:
            return "Can not decode data."
        case .errorUnknown:
            return "Unknown error"
        }
    }
}

final class Network {
    //MARK: - singleton
    private static var sharedNetworking: Network = {
        let networking = Network()
        return networking
    }()

    class func shared() -> Network {
        return sharedNetworking
    }

    //MARK: - init
    private init() {}

    //MARK: - request
    func request(with urlString: String, completion: @escaping (Result<Data,APIError>) -> Void) {
        let session = URLSession.shared

        guard let url = URL(string: urlString) else {
            completion(.failure(.errorURL))
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
            } else {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(.errorDataNotExist))
                }
            }
        }
        task.resume()
    }

    func request<T: Decodable>(with endPoint: Endpoint, completion: @escaping (Result<T,APIError>) -> Void) {
        let session = URLSession.shared
        let decoder = JSONDecoder()

        guard var components = URLComponents(string: endPoint.baseUrl) else {
            completion(.failure(.errorMalformedURL))
            return
        }

        //path
        components.path = endPoint.path

        // Parameters
        components.queryItems = endPoint.params?.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }

        // URL
        guard let url = components.url else {
            completion(.failure(.errorURL))
            return
        }
        var urlRequest = URLRequest(url: url)

        // HTTP Method
        urlRequest.httpMethod = endPoint.httpMethods.rawValue

        // HTTP Headers
        endPoint.headers?.forEach({ header in
            urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.error("Can not get http response")))
                return
            }

            guard let data = data else {
                completion(.failure(.errorDataNotExist))
                return
            }

            var errorMessage = ""
            if let error = try? decoder.decode(BaseResponse<ErrorResponse>.self, from: data) {
                errorMessage = error.data.error.first?.message ?? ""
            }

            let statusCode = httpResponse.statusCode
            switch statusCode {
            case 200:
                if errorMessage != "" {
                    completion(.failure(.error(errorMessage)))
                    return
                }

                do {
                    let decodeData = try decoder.decode(T.self, from: data)
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(.errorDecodedData))
                }
            case 400...499:
                completion(.failure(.errorRequestWithCode(statusCode, errorMessage)))
            case 500...599:
                completion(.failure(.errorRequestWithCode(statusCode, errorMessage)))
            default:
                completion(.failure(.errorUnknown))
            }
        }
        task.resume()
    }
}
