// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct MonitorStatusResponseData: Codable {
    let uid: String
    let status: Bool
}

typealias MonitorStatusResponse = APIResponseData<MonitorStatusResponseData>
