// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import OnboardKit

extension RootViewController {
    func showQuickStart() {
        let page1 = OnboardPage(
            title: "Intro 1",
            imageName: "quick_start_1",
            description: "Basic button introduction",
            advanceButtonTitle: "",
            actionButtonTitle: nil,
            action: nil
        )
        let page2 = OnboardPage(
            title: "Intro 2",
            imageName: "quick_start_2",
            description: """
            Tap top right button to add new monitor URL.
            Enter the URL you want to monitor in the text field.
            """,
            advanceButtonTitle: "",
            actionButtonTitle: nil,
            action: nil
        )
        let page3 = OnboardPage(
            title: "Intro 3",
            imageName: "quick_start_3",
            description: """
            In the status table, You can see the current status of the URL.
            """,
            advanceButtonTitle: "",
            actionButtonTitle: nil,
            action: nil
        )
        let page4 = OnboardPage(
            title: "Intro 4",
            imageName: "quick_start_4",
            description: """
            Notification
            """,
            advanceButtonTitle: "Done"
        )
        let pages = [page1, page2, page3, page4]

        let appearance = OnboardViewController.AppearanceConfiguration(
            tintColor: .black,
            titleColor: .black,
            textColor: .systemGray,
            backgroundColor: .white,
            imageContentMode: .scaleAspectFit,
            titleFont: UIFont.boldSystemFont(ofSize: 18),
            textFont: UIFont.boldSystemFont(ofSize: 16)
        )
        let onboardingViewController = OnboardViewController(pageItems: pages, appearanceConfiguration: appearance)
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: true)

    }
}
