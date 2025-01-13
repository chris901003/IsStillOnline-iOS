// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
