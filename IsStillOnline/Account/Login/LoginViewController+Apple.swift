// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth

extension LoginViewController: ASAuthorizationControllerDelegate {
    static var currentNonce: String?

    @objc func loginWithAppleAction() {
        LoginViewController.currentNonce = startSignInWithAppleFlow(delegate: self, presentation: self)
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

    func startSignInWithAppleFlow(delegate: ASAuthorizationControllerDelegate, presentation: ASAuthorizationControllerPresentationContextProviding) -> String {
        let nonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = presentation
        authorizationController.performRequests()
        return nonce
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
