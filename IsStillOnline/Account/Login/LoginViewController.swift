// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LoginViewController: UIViewController {
    let mainContentView = UIView()
    let titleView = UILabel()
    let emailView = LoginInputView(config: .init(
        title: "Email",
        placeholder: "Email Address",
        isPassword: false
    ))
    let passwordView = LoginInputView(config: .init(
        title: "Password",
        placeholder: "Your Password",
        isPassword: true
    ))
    let loginButton = UILabel()

    let manager = LoginManager()

    override func viewDidLoad() {
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        titleView.text = "Account"
        titleView.textColor = .black
        titleView.font = .systemFont(ofSize: 32, weight: .bold)
        titleView.textAlignment = .center

        emailView.delegate = manager
        passwordView.delegate = manager

        loginButton.text = "Login"
        loginButton.textColor = .black
        loginButton.font = .systemFont(ofSize: 26, weight: .bold)
        loginButton.isUserInteractionEnabled = true
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginAction)))
    }

    private func layout() {
        view.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        mainContentView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 0)
        let layout = mainContentView.layoutMarginsGuide

        mainContentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: layout.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        mainContentView.addSubview(emailView)
        emailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            emailView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            emailView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        mainContentView.addSubview(passwordView)
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 12),
            passwordView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            passwordView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        mainContentView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: layout.bottomAnchor)
        ])
    }
}

extension LoginViewController {
    @objc func loginAction() {
        if manager.email.isEmpty {
            emailView.updateError(err: "Email is empty")
            return
        }
        emailView.cleanError()
    }
}
