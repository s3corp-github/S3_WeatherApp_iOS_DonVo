//
//  UIView+Loading+Message.swift
//  WeatherApp
//
//  Created by don.vo on 12/27/22.
//

import UIKit

extension UIView {
    func addOnlySubView(_ subView: UIView) {
        guard !self.subviews.contains(subView) else { return }
        removeAllSubViews()
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.heightAnchor.constraint(equalTo: self.heightAnchor),
            subView.widthAnchor.constraint(equalTo: self.widthAnchor),
            subView.topAnchor.constraint(equalTo: self.topAnchor),
            subView.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }

    func removeAllSubViews() {
        _ = self.subviews.map({ view in
            view.removeFromSuperview()
        })
    }
}
