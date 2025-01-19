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
    let appleSignButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    let googleSignButton = GIDSignInButton()

    let manager = LoginManager()

    override func viewDidLoad() {
        setup()
        layout()
    }

    private func setup() {
        manager.delegate = self

        view.backgroundColor = .white

        titleView.text = "Login"
        titleView.textColor = .black
        titleView.font = .systemFont(ofSize: 32, weight: .bold)
        titleView.textAlignment = .center

        googleSignButton.style = .wide
        googleSignButton.addGestureRecognizer(UITapGestureRecognizer(target: manager, action: #selector(manager.loginWithGoogleAction)))

        appleSignButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithAppleAction)))
    }

    private func layout() {
        view.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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

        mainContentView.addSubview(appleSignButton)
        appleSignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleSignButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            appleSignButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            appleSignButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            appleSignButton.heightAnchor.constraint(equalToConstant: 45)
        ])

        mainContentView.addSubview(googleSignButton)
        googleSignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleSignButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            googleSignButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            googleSignButton.topAnchor.constraint(equalTo: appleSignButton.bottomAnchor, constant: 8),
            googleSignButton.bottomAnchor.constraint(equalTo: layout.bottomAnchor)
        ])
    }
}

// MARK: - LoginManagerDelegate
extension LoginViewController: LoginManagerDelegate {
    func showRootView() {
        let rootViewController = RootViewController()
        rootViewController.modalPresentationStyle = .fullScreen
        present(rootViewController, animated: true)
    }
}
