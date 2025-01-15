// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RVCLCLinkView: UIView {
    let titleView = UILabel()
    let linkImageView = UIImageView()
    let linkView = UILabel()

    var linkStr: String = "https://google.com"

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(linkStr: String) {
        self.linkStr = linkStr
        linkView.text = linkStr
    }

    private func setup() {
        titleView.text = "Link: "
        titleView.font = .systemFont(ofSize: 16, weight: .semibold)
        titleView.textColor = .black

        linkImageView.image = UIImage(systemName: "link")
        linkImageView.contentMode = .scaleAspectFit
        linkImageView.isUserInteractionEnabled = true
        linkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkJumpAction)))

        linkView.numberOfLines = 2
        linkView.lineBreakMode = .byTruncatingMiddle
        linkView.text = "https://google.com"
        linkView.font = .systemFont(ofSize: 14, weight: .semibold)
        linkView.textColor = .black
    }

    private func layout() {
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor)
        ])

        addSubview(linkImageView)
        linkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkImageView.topAnchor.constraint(equalTo: topAnchor),
            linkImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linkImageView.heightAnchor.constraint(equalToConstant: 25),
            linkImageView.widthAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(linkView)
        linkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 4),
            linkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            linkView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linkView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension RVCLCLinkView {
    @objc func linkJumpAction() {
        guard let url = URL(string: linkStr),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
