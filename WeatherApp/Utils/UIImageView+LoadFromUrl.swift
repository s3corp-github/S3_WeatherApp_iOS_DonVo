//
//  UIImageView+LoadFromString.swift
//  WeatherApp
//
//  Created by don.vo on 11/30/22.
//

import UIKit

extension UIImageView {
    func LoadFromUrl(url: String) {
        DispatchQueue.global().async {
            Networking.shared().request(with: url) { result in
                switch result {
                case .success(let data):
                    self.image = UIImage(data: data)
                case .failure(_):
                    self.image = UIImage()
                }
            }
        }
    }
}
