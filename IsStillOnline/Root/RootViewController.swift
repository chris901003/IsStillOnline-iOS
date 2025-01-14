// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RootViewController: UIViewController {
    let titleView = UILabel()
    let addNewLinkButton = RVCAddNewLinkView()
    let newUrlInputView = RVCNewUrlInputView()

    let manager = RootViewControllerManager()

    override func viewDidLoad() {
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        titleView.text = "Links"
        titleView.font = .systemFont(ofSize: 24, weight: .bold)
        titleView.textAlignment = .center

        addNewLinkButton.isUserInteractionEnabled = true
        addNewLinkButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUrlAction)))

        newUrlInputView.alpha = 0
        newUrlInputView.isHidden = true
        newUrlInputView.delegate = self
    }

    private func layout() {
        view.layoutMargins = .init(top: 8, left: 8, bottom: 0, right: 8)
        let layout = view.layoutMarginsGuide

        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: layout.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        view.addSubview(addNewLinkButton)
        addNewLinkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNewLinkButton.topAnchor.constraint(equalTo: layout.topAnchor),
            addNewLinkButton.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        view.addSubview(newUrlInputView)
        newUrlInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newUrlInputView.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
            newUrlInputView.centerYAnchor.constraint(equalTo: layout.centerYAnchor)
        ])
    }
}

// MARK: - Utility
extension RootViewController {
    @objc func addUrlAction() {
        newUrlInputView.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            newUrlInputView.alpha = 1
        }
    }
}

// MARK: - RVCNewUrlInputViewDelegate
extension RootViewController: RVCNewUrlInputViewDelegate {
    func inputCancel() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            newUrlInputView.alpha = 0
        } completion: { [weak self] _ in
            guard let self else { return }
            newUrlInputView.isHidden = true
        }
    }

    func addNewUrl(url: String) {
        Task {
            do {
                if try await manager.addNewUrl(url: url) {
                    addBanner(config: .init(message: "Add url \(url)", backgroundColor: .systemGreen))
                } else {
                    addBanner(config: .init(message: "Fail add url \(url)", backgroundColor: .systemRed))
                }
            } catch {
                addBanner(config: .init(message: "Error: \(error.localizedDescription)", backgroundColor: .systemRed))
            }
            await MainActor.run { inputCancel() }
        }
    }
}
