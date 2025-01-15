// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCLinkCell: UITableViewCell {
    let mainContentView = UIView()
    let statusCodeView = RVCLCStatusCodeView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderColor = UIColor.black.cgColor
        mainContentView.layer.borderWidth = 1.5
    }

    private func layout() {
        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])

        mainContentView.layoutMargins = .init(top: 8, left: 12, bottom: 8, right: 8)
        let layout = mainContentView.layoutMarginsGuide

        mainContentView.addSubview(statusCodeView)
        statusCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusCodeView.topAnchor.constraint(equalTo: layout.topAnchor),
            statusCodeView.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
            statusCodeView.leadingAnchor.constraint(equalTo: layout.leadingAnchor)
        ])
    }
}
