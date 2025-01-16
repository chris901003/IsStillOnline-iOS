// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCBottomViewController: UIViewController {
    let topBarView = UIView()
    let titleView = UILabel()
    let linkImageView = UIImageView()
    let statusCodeView = RVCLCStatusCodeView()
    let statusLabelView = RVCLCStatusLabelView()
    let updateLabel = UILabel()
    let linkLabel = UILabel()

    var config: RVCLinkCellConfig
    var url = URL(string: "https://google.com")!

    init(config: RVCLinkCellConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        topBarView.backgroundColor = .systemGray
        topBarView.layer.cornerRadius = 2.5

        titleView.text = "Link Status"
        titleView.textColor = .black
        titleView.textAlignment = .center
        titleView.font = .systemFont(ofSize: 16, weight: .bold)

        linkImageView.image = UIImage(systemName: "link.circle")
        linkImageView.contentMode = .scaleAspectFit
        linkImageView.isUserInteractionEnabled = true
        linkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkJumpAction)))

        updateLabel.textColor = .systemGray
        updateLabel.textAlignment = .left
        updateLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        linkLabel.textColor = .black
        linkLabel.textAlignment = .center
        linkLabel.font = .systemFont(ofSize: 16, weight: .bold)
        linkLabel.numberOfLines = 0

        statusCodeView.config(statusCode: config.statusCode, isSuccess: config.isSuccess)
        statusLabelView.config(code: config.statusCode)
        updateLabel.text = "Update at \(DateFormatterManager.shared.dateFormat(type: .MM_dd_HH_mm, date: config.updateTime))"
        linkLabel.text = "Link: \(config.url)"
        url = URL(string: config.url)!
    }

    private func layout() {
        view.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        let layout = view.layoutMarginsGuide

        view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBarView.widthAnchor.constraint(equalToConstant: 40),
            topBarView.heightAnchor.constraint(equalToConstant: 5)
        ])

        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 12),
            titleView.heightAnchor.constraint(equalToConstant: 18),
            titleView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        view.addSubview(linkImageView)
        linkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkImageView.topAnchor.constraint(equalTo: layout.topAnchor),
            linkImageView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
            linkImageView.heightAnchor.constraint(equalToConstant: 35),
            linkImageView.widthAnchor.constraint(equalToConstant: 35)
        ])

        view.addSubview(statusCodeView)
        statusCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusCodeView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 12),
            statusCodeView.leadingAnchor.constraint(equalTo: layout.leadingAnchor)
        ])

        view.addSubview(statusLabelView)
        statusLabelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabelView.leadingAnchor.constraint(equalTo: statusCodeView.trailingAnchor, constant: 16),
            statusLabelView.bottomAnchor.constraint(equalTo: statusCodeView.centerYAnchor, constant: -12)
        ])

        view.addSubview(updateLabel)
        updateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateLabel.topAnchor.constraint(equalTo: statusCodeView.centerYAnchor, constant: 12),
            updateLabel.leadingAnchor.constraint(equalTo: statusCodeView.trailingAnchor, constant: 16)
        ])

        view.addSubview(linkLabel)
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkLabel.topAnchor.constraint(equalTo: statusCodeView.bottomAnchor, constant: 12),
            linkLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            linkLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
            linkLabel.bottomAnchor.constraint(equalTo: layout.bottomAnchor)
        ])
    }

    @objc private func linkJumpAction() {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
