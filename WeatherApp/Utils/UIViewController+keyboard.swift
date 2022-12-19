//
//  UIViewController+keyboard.swift
//  WeatherApp
//
//  Created by don.vo on 12/19/22.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        navigationItem.titleView?.endEditing(true)
        view.endEditing(true)
    }

    func handleKeyboardContrain(contrainBottom: NSLayoutConstraint) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
          forName: UIResponder.keyboardWillChangeFrameNotification,
          object: nil, queue: .main) { (notification) in
              self.handleKeyboard(notification: notification, contrainBottom: contrainBottom)
        }
        notificationCenter.addObserver(
          forName: UIResponder.keyboardWillHideNotification,
          object: nil, queue: .main) { (notification) in
              self.handleKeyboard(notification: notification, contrainBottom: contrainBottom)
        }

    }

    private func handleKeyboard(notification: Notification, contrainBottom: NSLayoutConstraint) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            contrainBottom.constant = 0
            view.layoutIfNeeded()
            return
        }

        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            contrainBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
}
