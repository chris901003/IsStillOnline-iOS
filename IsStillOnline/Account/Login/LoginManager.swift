// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth

protocol LoginManagerDelegate: AnyObject {
    func showRootView()
}

class LoginManager {
    let apiManager = APIManager()

    var email: String = ""
    var password: String = ""

    weak var delegate: LoginManagerDelegate?

    func checkEmail() -> String? {
        guard !email.isEmpty else { return "Email is empty" }
        guard email.isValidEmail() else { return "Invalid email" }
        return nil
    }

    func checkPassword() -> String? {
        guard password.count >= 6 else { return "Password is too short" }
        return nil
    }

    @discardableResult
    func loginAction() async throws -> LoginResponse {
//        try await apiManager.loginWith(email: email, password: password)
        return .init(success: true, message: "", data: .init(email: "", uid: ""))
    }

    func createToken() async throws {
        try await apiManager.createToken()
        try await apiManager.updateFirebaseToken()
    }

    func loginWithThirdParty(email: String, uid: String) async {
        do {
            try await apiManager.loginWith(email: email, uid: uid)
            try await createToken()
            await MainActor.run { delegate?.showRootView() }
        } catch {
            print("✅ [LM] Error: \(error.localizedDescription)")
        }
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

extension LoginManager {
    @objc func loginWithGoogleAction() {
        Task { await loginWithGoogle() }
    }

    @MainActor
    private func loginWithGoogle() async {
        guard let topVC = UIViewController.getTopViewController() else { return }
        do {
            let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            guard let idToken = gidSignInResult.user.idToken?.tokenString else { return }
            let accessToken = gidSignInResult.user.accessToken.tokenString
            let credentail = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authDataResult = try await Auth.auth().signIn(with: credentail)
            guard let email = authDataResult.user.email else { return }
            await loginWithThirdParty(email: email, uid: authDataResult.user.uid)
        } catch {
            print("✅ Error: \(error.localizedDescription)")
        }
    }
}
