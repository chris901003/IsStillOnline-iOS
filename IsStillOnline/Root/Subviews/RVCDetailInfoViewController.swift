// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCDetailInfoViewController: UIViewController {
    let topBarView = UIView()
    let titleView = LeadingIconLabelView(iconName: "info.circle", title: "About")
    let infoLabel = UILabel()

    private let infoText = """
This app is designed specifically to monitor the status of URLs.
Users can easily add the URLs they want to track, and the app will perform a GET request every hour to check if the URLs are functioning properly.
If any issues are detected during monitoring, we will immediately notify you with the latest status of the URL, ensuring you stay informed in real time.
Whether for personal or business use, our app offers an efficient and reliable solution for URL monitoring.
"""

    override func viewDidLoad() {
        setup()
        layout()
        calHeight()
    }

    private func setup() {
        view.backgroundColor = .white

        topBarView.backgroundColor = .systemGray
        topBarView.layer.cornerRadius = 2.5

        infoLabel.text = infoText
        infoLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        infoLabel.textColor = .systemGray
        infoLabel.numberOfLines = 0
    }

    private func layout() {
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
            titleView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 8),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func calHeight() {
        let tmpTitleLabel = UILabel(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        tmpTitleLabel.numberOfLines = 1
        tmpTitleLabel.text = "Title"
        tmpTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        tmpTitleLabel.sizeToFit()
        let titleViewHeight = tmpTitleLabel.bounds.height

        let tmpInfoLabel = UILabel(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        tmpInfoLabel.numberOfLines = 0
        tmpInfoLabel.text = infoText
        tmpInfoLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tmpInfoLabel.sizeToFit()
        let infoLabelHeight = tmpInfoLabel.bounds.height

        preferredContentSize = .init(
            width: UIScreen.main.bounds.width,
            height: (8 + 5) + (8 + titleViewHeight) + (8 + infoLabelHeight + 32)
        )
    }
}
