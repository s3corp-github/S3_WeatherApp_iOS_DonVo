//
//  MessageView.swift
//  WeatherApp
//
//  Created by don.vo on 12/26/22.
//

import UIKit

class MessageView: UIView {
    private var messageView: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        messageView = UILabel(frame: frame)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.textColor = UIColor.black
        messageView.numberOfLines = 0;
        messageView.textAlignment = .center;
        messageView.sizeToFit()
        self.addSubview(messageView)

        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: self.topAnchor),
            messageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMessage(_ message: String) {
        messageView.text = message
    }
}
