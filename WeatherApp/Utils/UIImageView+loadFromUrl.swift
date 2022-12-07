//
//  UIImageView+LoadFromString.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import UIKit

extension UIImageView {
    func loadFromUrl(url: String) {
        DispatchQueue.global().async {
            Network.shared().request(with: url) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.image = UIImage()
                    }
                }
            }
        }
    }
}
