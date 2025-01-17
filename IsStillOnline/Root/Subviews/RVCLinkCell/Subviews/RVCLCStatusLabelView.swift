// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension RVCLCStatusLabelView {
    static let httpStatusCodes: [String: String] = [
        // 1xx Informational
        "100": "Continue",
        "101": "Switching Protocols",

        // 2xx Success
        "200": "OK",
        "201": "Created",
        "202": "Accepted",
        "204": "No Content",

        // 3xx Redirection
        "301": "Moved Permanently",
        "302": "Found",
        "303": "See Other",
        "304": "Not Modified",

        // 4xx Client Error
        "400": "Bad Request",
        "401": "Unauthorized",
        "403": "Forbidden",
        "404": "Not Found",
        "405": "Method Not Allowed",
        "408": "Timeout",
        "429": "Too Many Requests",

        // 5xx Server Error
        "500": "Internal Server Error",
        "501": "Not Implemented",
        "502": "Bad Gateway",
        "503": "Service Unavailable",
        "504": "Gateway Timeout"
    ]
}

class RVCLCStatusLabelView: UIView {
    let titleLabel = UILabel()
    let infoLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(code: String) {
        if let info = RVCLCStatusLabelView.httpStatusCodes[code] {
            infoLabel.text = info
        } else {
            infoLabel.text = "Unknown Status"
        }
    }

    private func setup() {
        titleLabel.text = "Status: "
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        infoLabel.text = RVCLCStatusLabelView.httpStatusCodes["200"]
        infoLabel.textColor = .black
        infoLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
