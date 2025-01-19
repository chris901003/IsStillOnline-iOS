// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension UIViewController {
    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }

    func addBanner(config: BannerViewConfig) {
        let bannerView = BannerView(config: config)
        var bannerViewBottomConstraint: NSLayoutConstraint?

        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else { return }
        
        window.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        bannerViewBottomConstraint = bannerView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 75)
        bannerViewBottomConstraint?.isActive = true
        window.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, animations: {
            bannerViewBottomConstraint?.constant = 0
            window.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: {
                    bannerViewBottomConstraint?.constant = 75
                    window.layoutIfNeeded()
                }) { _ in
                    bannerView.removeFromSuperview()
                }
            }
        }
    }
}
