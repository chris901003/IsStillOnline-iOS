// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    static var uid: String? {
        didSet {
            if let uid {
                KeychainManager.saveToKeychain(key: KEYCHAIN_USER_UID, value: uid)
            }
        }
    }
    static var token: String? {
        didSet {
            if let token {
                KeychainManager.saveToKeychain(key: KEYCHAIN_TOKEN, value: token)
            }
        }
    }
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
                let request = try addAccessToken(request: request)
                return try await sendRequestFlow(request: request, dataType: dataType)
            } else if httpResponse.statusCode != 200 {
                print("✅ Status code: \(httpResponse.statusCode)")
                throw APIError.urlSession
            }
        }
        let result = try APIManager.decoder.decode(dataType, from: data)
        return result
    }

    func checkToken() async -> Bool {
        guard let uid = KeychainManager.getFromKeychain(key: KEYCHAIN_USER_UID),
              let token = KeychainManager.getFromKeychain(key: KEYCHAIN_TOKEN) else { return false }
        APIManager.uid = uid
        APIManager.token = token
        guard let _ = try? await getMonitorUrls() else {
            return false
        }
        return true
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
        let url = Links.refreshToken.getUrl()
        var request = Methods.get.getRequest(url: url)
        request = try addAccessToken(request: request)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {return false }
        let result = try APIManager.decoder.decode(TokenResponse.self, from: data)
        APIManager.token = result.data.token
        return true
    }
}
