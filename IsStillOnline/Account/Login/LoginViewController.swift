// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    let mainContentView = UIView()
    let titleView = UILabel()
    let emailView = LoginInputView(config: .init(
        title: "Email",
        placeholder: "Email Address",
        isPassword: false,
        keyboardType: .emailAddress
    ))
    let passwordView = LoginInputView(config: .init(
        title: "Password",
        placeholder: "Your Password",
        isPassword: true,
        keyboardType: .alphabet
    ))
    let loginButton = UILabel()
    let loginLoading = UIActivityIndicatorView()
    let loginErrorMessageView = UILabel()
    let appleSignButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    let googleSignButton = GIDSignInButton()

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

        loginLoading.color = .black
        loginLoading.style = .large
        loginLoading.alpha = 0

        loginErrorMessageView.alpha = 0
        loginErrorMessageView.textColor = .systemPink
        loginErrorMessageView.font = .systemFont(ofSize: 16, weight: .semibold)
        loginErrorMessageView.textAlignment = .center

        googleSignButton.style = .wide
        googleSignButton.addGestureRecognizer(UITapGestureRecognizer(target: manager, action: #selector(manager.loginWithGoogleAction)))

        appleSignButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithAppleAction)))
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
            loginButton.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 32),
            loginButton.centerXAnchor.constraint(equalTo: layout.centerXAnchor)
        ])

        mainContentView.addSubview(loginLoading)
        loginLoading.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginLoading.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loginLoading.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])

        mainContentView.addSubview(loginErrorMessageView)
        loginErrorMessageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginErrorMessageView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            loginErrorMessageView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            loginErrorMessageView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
            loginErrorMessageView.bottomAnchor.constraint(equalTo: layout.bottomAnchor)
        ])

        view.addSubview(appleSignButton)
        appleSignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleSignButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appleSignButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            appleSignButton.topAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: 8),
            appleSignButton.heightAnchor.constraint(equalToConstant: 45)
        ])

        view.addSubview(googleSignButton)
        googleSignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleSignButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            googleSignButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            googleSignButton.topAnchor.constraint(equalTo: appleSignButton.bottomAnchor, constant: 8)
        ])
    }
}

extension LoginViewController {
    @objc func loginAction() {
        var isValid = true
        if let emailErrorMessage = manager.checkEmail() {
            emailView.updateError(err: emailErrorMessage)
            isValid = false
        }
        if let passwordErrorMessage = manager.checkPassword() {
            passwordView.updateError(err: passwordErrorMessage)
            isValid = false
        }
        guard isValid else { return }

        emailView.cleanError()
        passwordView.cleanError()

        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self else { return }
            loginButton.alpha = 0
            loginLoading.startAnimating()
            loginLoading.alpha = 1
        }

        Task {
            do {
                try await manager.loginAction()
                try await manager.createToken()

                await MainActor.run {
                    let rootViewController = RootViewController()
                    rootViewController.modalPresentationStyle = .fullScreen
                    present(rootViewController, animated: true)
                }
            } catch {
                await MainActor.run {
                    UIView.animate(withDuration: 0.25) { [weak self] in
                        guard let self else { return }
                        loginErrorMessageView.alpha = 1
                        loginErrorMessageView.text = "Email or Password wrong."
                        loginButton.alpha = 1
                        loginLoading.alpha = 0
                        loginLoading.stopAnimating()
                    }
                }
            }
        }
    }
}
