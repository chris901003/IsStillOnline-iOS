// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    enum Links {
        case login, refreshToken, createNewMonitorUrl, deleteUrl, startMonitor, stopMonitor, deleteToken, updateFirebaseToken
        case createToken, monitorUrls, monitorStatus

        func getUrl() -> URL {
            switch self {
                case .login:
                    return URL(string: LOGIN_URL)!
                case .refreshToken:
                    return URL(string: REFRESH_TOKEN_URL)!
                case .createNewMonitorUrl:
                    return URL(string: CREATE_URL)!
                case .deleteUrl:
                    return URL(string: DELETE_URL)!
                case .startMonitor:
                    return URL(string: MONITOR_START)!
                case .stopMonitor:
                    return URL(string: MONITOR_STOP)!
                case .deleteToken:
                    return URL(string: DELETE_TOKEN_URL)!
                case .updateFirebaseToken:
                    return URL(string: UPDATE_FIREBASE_TOKEN)!
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
                case .monitorStatus:
                    return URLComponents(string: MONITOR_STATUS)!
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
    func addJsonBody(request: URLRequest, data: [String: Any]) throws -> URLRequest {
        var request = request
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data)
        } catch {
            throw APIError.jsonSerialization
        }
        return request
    }

    func loginWith(email: String, password: String) async throws -> LoginResponse {
        let url = Links.login.getUrl()
        var request = Methods.post.getRequest(url: url)
        let parameters: [String: Any] = [
            "email": email, "password": password
        ]
        request = try addJsonBody(request: request, data: parameters)

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

    func deleteToken() async -> Bool {
        let url = Links.deleteToken.getUrl()
        let request = Methods.get.getRequest(url: url)
        do {
            let result = try await sendRequestFlow(request: request, dataType: EmptyResponse.self)
            return result.success
        } catch {
            return false
        }
    }

    func getMonitorUrls() async throws -> MonitorResponse {
        let urlComponents = Links.monitorUrls.getUrlComponent()

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

    func createNewMonitorUrl(link: String) async throws -> Bool {
        let url = Links.createNewMonitorUrl.getUrl()
        var request = Methods.post.getRequest(url: url)
        let parameters: [String: Any] = ["url": link]
        request = try addJsonBody(request: request, data: parameters)

        do {
            let result = try await sendRequestFlow(request: request, dataType: EmptyResponse.self)
            return result.success
        } catch {
            throw APIError.urlSession
        }
    }

    func deleteMonitorUrl(link: String) async throws -> Bool {
        let url = Links.deleteUrl.getUrl()
        var request = Methods.post.getRequest(url: url)
        let parameters: [String: Any] = ["url": link]
        request = try addJsonBody(request: request, data: parameters)

        do {
            let result = try await sendRequestFlow(request: request, dataType: EmptyResponse.self)
            return result.success
        } catch {
            throw APIError.urlSession
        }
    }

    func isStartMonitor() async throws -> Bool {
        let urlComponents = Links.monitorStatus.getUrlComponent()
        guard let url = urlComponents.url else {
            throw APIError.url
        }
        let request = Methods.get.getRequest(url: url)

        do {
            let result = try await sendRequestFlow(request: request, dataType: MonitorStatusResponse.self)
            return result.data.status
        } catch {
            throw APIError.urlSession
        }
    }
}

// MARK: - Monitor Status
extension APIManager {
    func changeMonitorStatus(to status: Bool) async throws -> Bool {
        if status {
            return try await startMonitor()
        } else {
            return try await stopMonitor()
        }
    }

    private func startMonitor() async throws -> Bool {
        let url = Links.startMonitor.getUrl()
        let request = Methods.get.getRequest(url: url)
        do {
            let result = try await sendRequestFlow(request: request, dataType: EmptyResponse.self)
            return result.success
        }
    }

    private func stopMonitor() async throws -> Bool {
        let url = Links.stopMonitor.getUrl()
        let request = Methods.get.getRequest(url: url)
        do {
            let result = try await sendRequestFlow(request: request, dataType: EmptyResponse.self)
            return result.success
        }
    }
}
