//
//  UIImageView+LoadFromString.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import UIKit

fileprivate let imageCache = CacheHelper<String, UIImage>(cost: 50_000_000)

extension UIImageView {
    func loadFromUrl(url: String) {
        if let cachedImage = imageCache[url]  {
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async { [weak self] in
            Network.shared().request(with: url) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            self?.image = UIImage()
                        }
                        return
                    }
                    imageCache[url] = image
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.image = UIImage()
                    }
                }
            }
        }
    }
}
