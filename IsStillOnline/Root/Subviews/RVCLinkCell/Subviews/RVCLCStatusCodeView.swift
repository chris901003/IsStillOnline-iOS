// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCLCStatusCodeView: UIView {
    let statusView = UIView()
    let statusCodeLabel = UILabel()

    let blueGradientLayer = CAGradientLayer()
    let statusGradientLayer = CAGradientLayer()
    let greenColor = [
        UIColor(hex: "#1d976cff")?.cgColor as Any,
        UIColor(hex: "#93f9b9ff")?.cgColor as Any
    ]
    let redColor = [
        UIColor(hex: "#f85032ff")?.cgColor as Any,
        UIColor(hex: "#e73827ff")?.cgColor as Any
    ]

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blueGradientLayer.colors = [
            UIColor(hex: "#2980b9ff")?.cgColor as Any,
            UIColor(hex: "#6dd5faff")?.cgColor as Any,
            UIColor(hex: "#ffffffff")?.cgColor as Any
        ]
        blueGradientLayer.startPoint = CGPoint(x: 0, y: 1)
        blueGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        blueGradientLayer.frame = bounds
        blueGradientLayer.cornerRadius = 55.0
        layer.insertSublayer(blueGradientLayer, at: 0)

        statusGradientLayer.colors = greenColor
        statusGradientLayer.startPoint = CGPoint(x: 0, y: 1)
        statusGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        statusGradientLayer.frame = statusView.bounds
        statusGradientLayer.cornerRadius = 50.0
        statusView.layer.insertSublayer(statusGradientLayer, at: 0)

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 55).cgPath
    }

    private func setup() {
        layer.cornerRadius = 55.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 5
        layer.cornerRadius = 10

        statusView.layer.borderWidth = 2.5
        statusView.layer.borderColor = UIColor.black.cgColor
        statusView.layer.cornerRadius = 50.0

        statusCodeLabel.text = "200"
        statusCodeLabel.textColor = .white
        statusCodeLabel.font = .systemFont(ofSize: 32, weight: .bold)
    }

    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 110),
            widthAnchor.constraint(equalToConstant: 110)
        ])

        addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.heightAnchor.constraint(equalToConstant: 100),
            statusView.widthAnchor.constraint(equalToConstant: 100),
            statusView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        statusView.addSubview(statusCodeLabel)
        statusCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusCodeLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusCodeLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
    }

    func config(statusCode: String, isSuccess: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            statusCodeLabel.text = statusCode
            statusGradientLayer.colors = isSuccess ? greenColor : redColor
            setNeedsDisplay()
        }
    }
}
