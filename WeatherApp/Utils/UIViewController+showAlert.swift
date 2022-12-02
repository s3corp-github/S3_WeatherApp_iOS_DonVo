//
//  UIViewController+showAlert.swift
//  WeatherApp
//
//  Created by don.vo on 12/2/22.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String, title: String, action: @escaping () -> Void ) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: title, style: .destructive) { _ in
            action()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
