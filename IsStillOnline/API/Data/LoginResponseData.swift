// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LoginResponseData: Codable {
    let email: String
    let uid: String
}

typealias LoginResponse = APIResponseData<LoginResponseData>
