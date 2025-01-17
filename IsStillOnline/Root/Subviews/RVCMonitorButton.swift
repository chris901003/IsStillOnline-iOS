// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCMonitorButton: UIView {
    let iconView = UIImageView()
    let labelView = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(isStart: Bool) {
        backgroundColor = isStart ? .systemPink : .systemBlue
        let imageName = isStart ? "stop" : "arrowtriangle.forward"
        iconView.image = UIImage(systemName: imageName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        labelView.text = isStart ? "Stop" : "Start"
    }

    private func setup() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 35

        iconView.image = UIImage(systemName: "arrowtriangle.forward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit

        labelView.text = "Start"
        labelView.textColor = .white
        labelView.font = .systemFont(ofSize: 12, weight: .semibold)
    }

    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            widthAnchor.constraint(equalToConstant: 70)
        ])

        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -6),
            iconView.heightAnchor.constraint(equalToConstant: 25),
            iconView.widthAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 2),
            labelView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor)
        ])
    }
}
