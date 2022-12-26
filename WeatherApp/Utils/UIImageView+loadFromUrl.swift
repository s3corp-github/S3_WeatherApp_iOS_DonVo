//
//  UIImageView+LoadFromString.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import UIKit

fileprivate let imageCache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.totalCostLimit = 50_000_000
    return cache
}()

extension UIImageView {
    func loadFromUrl(url: String) {
        if let cachedImage = imageCache.object(forKey: url as NSString)  {
            self.image = cachedImage
        } else {
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
                        imageCache.setObject(image, forKey: url as NSString)
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
}
