// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import AuthenticationServices
import FirebaseAuth
import xxooooxxCommonFunction

extension LoginViewController: ASAuthorizationControllerDelegate {
    static var currentNonce: String?

    @objc func loginWithAppleAction() {
        LoginViewController.currentNonce = AppleLoginFlow.startSignWithAppleFlow(delegate: self, presentation: self)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = LoginViewController.currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            Task {
                do {
                    let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
                    let authDataResult = try await Auth.auth().signIn(with: credential)
                    guard let email = authDataResult.user.email else { return }
                    await manager.loginWithThirdParty(email: email, uid: authDataResult.user.uid)
                } catch {
                    print("✅ Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) { }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
