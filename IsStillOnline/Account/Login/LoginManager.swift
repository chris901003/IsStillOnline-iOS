// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class LoginManager {
    var email: String = ""
    var password: String = ""

    func checkEmail() -> String? {
        guard !email.isEmpty else { return "Email is empty" }
        guard email.isValidEmail() else { return "Invalid email" }
        return nil
    }

    func checkPassword() -> String? {
        guard password.count >= 6 else { return "Password is too short" }
        return nil
    }
}

// MARK: - LoginInputViewDelegate
extension LoginManager: LoginInputViewDelegate {
    func updateInput(text: String, type: LoginInputView.InputType) {
        switch type {
            case .email:
                email = text
            case .password:
                password = text
        }
    }
}
