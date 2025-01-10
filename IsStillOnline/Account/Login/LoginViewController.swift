// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LoginViewController: UIViewController {
    let mainContentView = UIView()
    let titleView = UITextView()

    override func viewDidLoad() {
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        titleView.text = "Login"
        titleView.textColor = .black
        titleView.font = .systemFont(ofSize: 32, weight: .bold)
        titleView.textAlignment = .center

        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginAction)))
    }

    private func layout() {
        view.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainContentView.heightAnchor.constraint(equalToConstant: 300),
            mainContentView.widthAnchor.constraint(equalToConstant: 300)
        ])

        mainContentView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 0)
        let layout = mainContentView.layoutMarginsGuide

        mainContentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: layout.topAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 50),
            titleView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])
    }
}

extension LoginViewController {
    @objc func loginAction() {
        print("✅ Tapped")
        guard let url = URL(string: LOGIN_URL) else {
            print("✅ Invalid url")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "email": "hongyan@zephyrhuang.com",
            "password": "123456"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("✅ Request error: \(error.localizedDescription)")
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("請求失敗: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP 狀態碼: \(httpResponse.statusCode)")
            }
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("回應資料: \(jsonResponse)")
                } catch {
                    print("無法解析回應: \(error)")
                }
            }
        }
        task.resume()
    }
}
