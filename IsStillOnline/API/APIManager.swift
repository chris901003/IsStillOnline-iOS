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
        case createToken, monitorUrls

        func getUrl() -> URL {
            switch self {
                case .login:
                    return URL(string: LOGIN_URL)!
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

        var errorDescription: String? {
            switch self {
                case .jsonSerialization:
                    return "Json serialization failed"
                case .urlSession:
                    return "Url session failed"
                case .url:
                    return "Invalid url"
            }
        }
    }
}

class APIManager {
    static var token: String?

    static func sendRequest<T: Codable>(request: URLRequest, dataType: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let result = try decoder.decode(dataType, from: data)
        return result
    }

    func addAccessToken(request: URLRequest) -> URLRequest {
        guard let token = APIManager.token else { return request }
        var request = request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

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
            let result = try await APIManager.sendRequest(request: request, dataType: LoginResponse.self)
            return result
        } catch {
            throw APIError.urlSession
        }
    }

    func createToken(uid: String) async throws -> TokenResponse {
        var urlComponents = Links.createToken.getUrlComponent()
        urlComponents.queryItems = [URLQueryItem(name: "uid", value: uid)]

        guard let url = urlComponents.url else {
            throw APIError.url
        }

        let request = Methods.get.getRequest(url: url)
        do {
            let result = try await APIManager.sendRequest(request: request, dataType: TokenResponse.self)
            APIManager.token = result.data.token
            return result
        } catch {
            throw APIError.urlSession
        }
    }

    func getMonitorUrls(uid: String) async throws -> MonitorResponse {
        var urlComponents = Links.monitorUrls.getUrlComponent()
        urlComponents.queryItems = [URLQueryItem(name: "owner", value: uid)]

        guard let url = urlComponents.url else {
            throw APIError.url
        }

        var request = Methods.get.getRequest(url: url)
        request = addAccessToken(request: request)
        do {
            let result = try await APIManager.sendRequest(request: request, dataType: MonitorResponse.self)
            return result
        } catch {
            throw APIError.urlSession
        }
    }
}
