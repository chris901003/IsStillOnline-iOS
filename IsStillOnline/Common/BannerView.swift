// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct BannerViewConfig {
    let message: String
    let backgroundColor: UIColor
}

class BannerView: UIView {
    let messageLabel = UILabel()

    let config: BannerViewConfig

    init(config: BannerViewConfig) {
        self.config = config
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = config.backgroundColor

        messageLabel.text = config.message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
    }

    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            heightAnchor.constraint(equalToConstant: 75)
        ])

        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
