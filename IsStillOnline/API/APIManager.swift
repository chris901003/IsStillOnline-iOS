// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    enum Links {
        case login, refreshToken
        case createToken, monitorUrls

        func getUrl() -> URL {
            switch self {
                case .login:
                    return URL(string: LOGIN_URL)!
                case .refreshToken:
                    return URL(string: REFRESH_TOKEN_URL)!
                default:
                    return URL(string: BASE_URL)!
            }
        }

        func getUrlComponent() -> URLComponents {
            switch self {
                case .createToken:
                    return URLComponents(string: CREATE_TOKEN_URL)!
                case .monitorUrls:
                    return URLComponents(string: MONITOR_URLS)!
                default:
                    return URLComponents(string: BASE_URL)!
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
        case url
        case tokenNotFound
        case tokenExpired

        var errorDescription: String? {
            switch self {
                case .jsonSerialization:
                    return "Json serialization failed"
                case .urlSession:
                    return "Url session failed"
                case .url:
                    return "Invalid url"
                case .tokenNotFound:
                    return "Token not found"
                case .tokenExpired:
                    return "Token expired"
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
            let result = try await sendRequestFlow(request: request, dataType: LoginResponse.self, withToken: false)
            APIManager.uid = result.data.uid
            return result
        } catch {
            throw APIError.urlSession
        }
    }

    @discardableResult
    func createToken() async throws -> TokenResponse {
        var urlComponents = Links.createToken.getUrlComponent()
        urlComponents.queryItems = [URLQueryItem(name: "uid", value: APIManager.uid)]

        guard let url = urlComponents.url else {
            throw APIError.url
        }

        let request = Methods.get.getRequest(url: url)
        do {
            let result = try await sendRequestFlow(request: request, dataType: TokenResponse.self, withToken: false)
            APIManager.token = result.data.token
            return result
        } catch {
            throw APIError.urlSession
        }
    }

    func getMonitorUrls() async throws -> MonitorResponse {
        var urlComponents = Links.monitorUrls.getUrlComponent()
        urlComponents.queryItems = [URLQueryItem(name: "owner", value: APIManager.uid)]

        guard let url = urlComponents.url else {
            throw APIError.url
        }

        let request = Methods.get.getRequest(url: url)
        do {
            let result = try await sendRequestFlow(request: request, dataType: MonitorResponse.self)
            return result
        } catch {
            throw APIError.urlSession
        }
    }
}
