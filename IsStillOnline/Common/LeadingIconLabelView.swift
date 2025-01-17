// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LeadingIconLabelView: UIView {
    let iconView = UIImageView()
    let titleView = UILabel()

    init(iconName: String, title: String) {
        super.init(frame: .zero)
        setup(iconName: iconName, title: title)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(iconName: String, title: String) {
        iconView.image = UIImage(systemName: iconName)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit

        titleView.text = title
        titleView.textColor = .black
        titleView.font = .systemFont(ofSize: 20, weight: .bold)
        titleView.numberOfLines = 1
    }

    private func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.heightAnchor.constraint(equalTo: titleView.heightAnchor),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 4),
            titleView.topAnchor.constraint(equalTo: topAnchor),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
