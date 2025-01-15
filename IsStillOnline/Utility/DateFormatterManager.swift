// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum DateFormatType: String {
    case yyyy_MM_dd = "yyyy-MM-dd"
    case MM_dd_HH_mm = "MM-dd HH:mm"
}

class DateFormatterManager {
    // Singleton
    static let shared = DateFormatterManager()
    private init() { }

    let dateFormatter = DateFormatter()

    func dateFormat(type: DateFormatType, date: Date) -> String {
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
}
