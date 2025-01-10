// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct APIResponseData<T: Codable>: Codable {
    let success: Bool
    let message: String
    let data: T
}
