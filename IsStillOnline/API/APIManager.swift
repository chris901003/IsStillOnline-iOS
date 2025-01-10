// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

private extension APIManager {
    enum Links {
        case login

        func getUrl() -> URL {
            switch self {
                case .login:
                    return URL(string: LOGIN_URL)!
            }
        }
    }

    enum Methods: String {
        case get = "GET"
        case post = "POST"

        func getRequest(url: URL) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = self.rawValue

            if self == .post {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            return request
        }
    }

    enum APIError: LocalizedError {
        case jsonSerialization
        case urlSession

        var errorDescription: String? {
            switch self {
                case .jsonSerialization:
                    return "Json serialization failed"
                case .urlSession:
                    return "Url session failed"
            }
        }
    }
}

class APIManager {
    func loginWith(email: String, password: String) async throws -> LoginResponse {
        let url = Links.login.getUrl()
        var request = Methods.post.getRequest(url: url)
        let parameters: [String: Any] = [
            "email": email, "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw APIError.jsonSerialization
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let result = try decoder.decode(LoginResponse.self, from: data)
            return result
        } catch {
            throw APIError.urlSession
        }
    }
}
