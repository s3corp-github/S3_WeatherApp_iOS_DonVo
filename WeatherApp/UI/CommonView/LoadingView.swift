//
//  LoadingViewController.swift
//  WeatherApp
//
//  Created by don.vo on 12/26/22.
//

import UIKit

class LoadingView: UIView {
    private var spinner = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        self.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
