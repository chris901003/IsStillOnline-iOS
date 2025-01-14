// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol RVCNewUrlInputViewDelegate: AnyObject {
    func inputCancel()
    func addNewUrl(url: String)
}

class RVCNewUrlInputView: UIView {
    let titleView = UILabel()
    let urlTextView = UITextField()
    let bottomLineView = UIView()
    let cancelButton = PaddedTextField()
    let addButton = PaddedTextField()
    let loadingView = UIActivityIndicatorView()

    weak var delegate: RVCNewUrlInputViewDelegate?

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
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
    }

    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 15.0
        layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.borderWidth = 1.5

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .init(width: 5, height: 5)
        layer.shadowRadius = 10

        titleView.text = "Add New Url"
        titleView.textColor = .black
        titleView.font = .systemFont(ofSize: 18, weight: .bold)
        titleView.textAlignment = .center

        urlTextView.placeholder = "URL"
        urlTextView.textAlignment = .center
        urlTextView.keyboardType = .URL
        urlTextView.delegate = self
        urlTextView.autocorrectionType = .no

        bottomLineView.layer.cornerRadius = 2.0
        bottomLineView.backgroundColor = .black

        cancelButton.textInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        cancelButton.text = "Cancel"
        cancelButton.backgroundColor = .systemPink
        cancelButton.textColor = .white
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelAdd)))

        addButton.textInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        addButton.text = "Add"
        addButton.backgroundColor = .black
        addButton.textColor = .white
        addButton.layer.cornerRadius = 5.0
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewUrlAction)))

        loadingView.isHidden = true
        loadingView.style = .medium
    }

    private func layout() {
        layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        let layout = layoutMarginsGuide

        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: layout.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        addSubview(urlTextView)
        urlTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urlTextView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            urlTextView.widthAnchor.constraint(equalToConstant: 200),
            urlTextView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            urlTextView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        addSubview(bottomLineView)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLineView.topAnchor.constraint(equalTo: urlTextView.bottomAnchor, constant: 2),
            bottomLineView.heightAnchor.constraint(equalToConstant: 2),
            bottomLineView.leadingAnchor.constraint(equalTo: urlTextView.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: urlTextView.trailingAnchor)
        ])

        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: bottomLineView.bottomAnchor, constant: 8),
            cancelButton.trailingAnchor.constraint(equalTo: layout.centerXAnchor, constant: -12),
            cancelButton.bottomAnchor.constraint(equalTo: layout.bottomAnchor)
        ])

        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: bottomLineView.bottomAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: layout.centerXAnchor, constant: 12),
            addButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            addButton.bottomAnchor.constraint(equalTo: layout.bottomAnchor)
        ])

        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
}

extension RVCNewUrlInputView {
    @objc func addNewUrlAction() {
        loadingView.startAnimating()
        loadingView.isHidden = false
        cancelButton.alpha = 0.5
        cancelButton.isUserInteractionEnabled = false
        addButton.alpha = 0

        delegate?.addNewUrl(url: urlTextView.text ?? "")
    }

    @objc func cancelAdd() {
        delegate?.inputCancel()
    }
}

// MARK: - UITextFieldDelegate
extension RVCNewUrlInputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        bottomLineView.backgroundColor = .blue
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bottomLineView.backgroundColor = .black
        textField.resignFirstResponder()
        return true
    }
}
