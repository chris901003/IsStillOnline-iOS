// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    static var token: String?
    static let decoder = JSONDecoder()

    /**
     通用 API 呼叫，會協助提供 Access Token 以及更新 Access Token
     - Authors: HongYan
     */
    func sendRequestFlow<T: Codable>(request: URLRequest, dataType: T.Type, withToken: Bool = true) async throws -> T {
        var request = request
        if withToken {
            request = try addAccessToken(request: request)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401, withToken {
                guard try await refreshAccessToken() else {
                    throw APIError.tokenExpired
                }
            } else if httpResponse.statusCode != 200 {
                throw APIError.urlSession
            }
        }
        let result = try APIManager.decoder.decode(dataType, from: data)
        return result
    }

    /**
     將 Access Token 放入到 Authorization 當中
     - Authors: HongYan
     */
    private func addAccessToken(request: URLRequest) throws -> URLRequest {
        guard let token = APIManager.token else {
            throw APIError.tokenNotFound
        }
        var request = request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    /**
     透過 Refresh Token 獲取新的 Token，若 Refresh Token 過期返回 False
     - Authors: HongYan
     */
    private func refreshAccessToken() async throws -> Bool {
        guard let token = APIManager.token else {
            throw APIManager.APIError.tokenNotFound
        }
        let url = Links.refreshToken.getUrl()
        var request = Methods.post.getRequest(url: url)
        request = try addAccessToken(request: request)
        let parameter: [String: Any] = ["token": token]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
        } catch {
            throw APIError.jsonSerialization
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { return false }
        let result = try APIManager.decoder.decode(TokenResponse.self, from: data)
        APIManager.token = result.data.token
        return true
    }
}
