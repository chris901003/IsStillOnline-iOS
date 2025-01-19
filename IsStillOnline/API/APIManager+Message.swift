// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    static var firebaseToken: String?

    @discardableResult
    func updateFirebaseToken(token: String? = nil) async throws -> Bool {
        guard let token = token ?? APIManager.firebaseToken else { return false }
        let url = Links.updateFirebaseToken.getUrl()
        var request = Methods.post.getRequest(url: url)
        let parameters: [String: Any] = ["fbToken": token]
        request = try addJsonBody(request: request, data: parameters)
        do {
            let result = try await sendRequestFlow(request: request, dataType: EmptyResponse.self)
            return result.success
        } catch {
            return false
        }
    }
}
