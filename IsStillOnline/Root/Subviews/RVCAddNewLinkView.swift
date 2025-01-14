// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCAddNewLinkView: UIView {
    let titleView = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .black
        layer.cornerRadius = 10.0

        titleView.text = "Add new link"
        titleView.textColor = .white
        titleView.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    private func layout() {
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
}
