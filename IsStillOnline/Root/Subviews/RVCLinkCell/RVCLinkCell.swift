// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct RVCLinkCellConfig {
    let url: String
    let statusCode: String
    let isSuccess: Bool
    let updateTime: Date
}

class RVCLinkCell: UITableViewCell {
    let mainContentView = UIView()
    let statusCodeView = RVCLCStatusCodeView()
    let linkView = RVCLCLinkView()
    let statusView = RVCLCStatusLabelView()
    let updateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(config: RVCLinkCellConfig) {
        statusCodeView.config(statusCode: config.statusCode, isSuccess: config.isSuccess)
        linkView.config(linkStr: config.url)
        statusView.config(code: config.statusCode)
        updateLabel.text = "Update: \(DateFormatterManager.shared.dateFormat(type: .MM_dd_HH_mm, date: config.updateTime))"
    }

    private func setup() {
        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderColor = UIColor.black.cgColor
        mainContentView.layer.borderWidth = 1.5

        updateLabel.text = "Update: \(DateFormatterManager.shared.dateFormat(type: .MM_dd_HH_mm, date: Date.now))"
        updateLabel.textColor = .systemGray
        updateLabel.font = .systemFont(ofSize: 12, weight: .bold)
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

        mainContentView.addSubview(linkView)
        linkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkView.leadingAnchor.constraint(equalTo: statusCodeView.trailingAnchor, constant: 12),
            linkView.topAnchor.constraint(equalTo: layout.topAnchor, constant: 4),
            linkView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        mainContentView.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.leadingAnchor.constraint(equalTo: statusCodeView.trailingAnchor, constant: 12),
            statusView.topAnchor.constraint(equalTo: linkView.bottomAnchor, constant: 4),
            statusView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        mainContentView.addSubview(updateLabel)
        updateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateLabel.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
            updateLabel.leadingAnchor.constraint(equalTo: statusCodeView.trailingAnchor, constant: 12),
            updateLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])
    }
}
