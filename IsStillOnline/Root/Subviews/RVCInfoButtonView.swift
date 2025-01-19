// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCInfoButtonView: UIView {
    let iconView = UIImageView()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(iconName: String, color: UIColor) {
        iconView.image = UIImage(systemName: iconName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        backgroundColor = color
    }

    private func setup() {
        backgroundColor = .black
        layer.cornerRadius = 20.0

        iconView.image = UIImage(systemName: "info")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
    }

    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 40),
            heightAnchor.constraint(equalToConstant: 40)
        ])

        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
