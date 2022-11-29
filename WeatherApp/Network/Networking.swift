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

final class Networking {
    //MARK: - singleton
    private static var sharedNetworking: Networking = {
        let networking = Networking()
        return networking
    }()

    class func shared() -> Networking {
        return sharedNetworking
    }

    //MARK: - init
    private init() {}

    //MARK: - request
    func request(with urlString: String, completion: @escaping (Data?, APIError?) -> Void) {
            guard let url = URL(string: urlString) else {
                let error = APIError.error("URL Error")
                completion(nil, error)
                return
            }

            let config = URLSessionConfiguration.ephemeral
            config.waitsForConnectivity = true

            let session = URLSession(configuration: config)
            let task = session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(nil, APIError.error(error.localizedDescription))
                    } else {
                        if let data = data {
                            completion(data, nil)
                        } else {
                           completion(nil, APIError.error("Data format is error."))
                        }
                    }
                }
            }
            task.resume()
        }
}
