// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct LoginInputViewConfig {
    let title: String
    let placeholder: String
    let isPassword: Bool
}

protocol LoginInputViewDelegate: AnyObject {
    func updateInput(text: String, type: LoginInputView.InputType)
}

extension LoginInputView {
    enum InputType {
        case email, password
    }
}

class LoginInputView: UIView {
    private let titleView = UILabel()
    private let textView = UITextField()
    private let errorMessageView = UILabel()

    private let type: InputType
    private var bottomConstraint: NSLayoutConstraint?

    weak var delegate: LoginInputViewDelegate?

    init(config: LoginInputViewConfig) {
        type = config.isPassword ? .password : .email
        super.init(frame: .zero)
        setup(config)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(_ config: LoginInputViewConfig) {
        titleView.text = config.title
        titleView.font = .boldSystemFont(ofSize: 16)

        textView.font = .systemFont(ofSize: 14, weight: .semibold)
        textView.layer.borderWidth = 2.5
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 15.0
        textView.textAlignment = .center
        textView.placeholder = config.placeholder
        textView.isSecureTextEntry = config.isPassword
        textView.clearButtonMode = .whileEditing
        textView.delegate = self
        textView.autocorrectionType = .no

        errorMessageView.font = .systemFont(ofSize: 14, weight: .semibold)
        errorMessageView.textColor = .systemPink
        errorMessageView.textAlignment = .right
        errorMessageView.alpha = 0
    }

    private func layout() {
        addSubview(titleView)
        addSubview(textView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 8),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.heightAnchor.constraint(equalToConstant: 50),
            textView.widthAnchor.constraint(equalToConstant: 200),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(errorMessageView)
        errorMessageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorMessageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorMessageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorMessageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4)
        ])

        bottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint?.isActive = true
    }

    func updateError(err: String) {
        let ori = errorMessageView.text ?? ""
        errorMessageView.text = err
        if ori.isEmpty {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                errorMessageView.alpha = 1
                bottomConstraint?.isActive = false
                bottomConstraint = errorMessageView.bottomAnchor.constraint(equalTo: bottomAnchor)
                bottomConstraint?.isActive = true
                layoutIfNeeded()
            }
        }
    }

    func cleanError() {
        let ori = errorMessageView.text ?? ""
        guard !ori.isEmpty else { return }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            errorMessageView.alpha = 0
            bottomConstraint?.isActive = false
            bottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)
            bottomConstraint?.isActive = true
            layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateInput(text: textField.text ?? "", type: type)
    }
}
