//
//  Networking.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import Foundation

enum APIError: Error {
    case error(String)
    case errorURL

    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
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
        guard let handleUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            let error = APIError.errorURL
            completion(.failure(error))
            return
        }

        guard let url = URL(string: handleUrl) else {
            let error = APIError.errorURL
            completion(.failure(error))
            return
        }

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(APIError.error(error.localizedDescription)))
                } else {
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(APIError.error("Data format is error.")))
                    }
                }
            }
        }
        task.resume()
    }
}
