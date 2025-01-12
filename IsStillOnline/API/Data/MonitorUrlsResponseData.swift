// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct MonitorUrlsResponseData: Codable {
    let owner: String
    let urls: [String]
}

typealias MonitorResponse = APIResponseData<MonitorUrlsResponseData>
