// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol RootViewControllerManagerDelegate: AnyObject {
    func showBanner(message: String, backgroundColor: UIColor)
    func reloadTable()
}

class RootViewControllerManager {
    let apiManager = APIManager()

    var linkCellConfigs = [RVCLinkCellConfig]()
    private var monitorUrls = [URL]()

    var delegate: RootViewControllerManagerDelegate? {
        didSet { delegate?.reloadTable() }
    }

    init() {
        Task {
            await fetchMonitorUrls()
            await checkAllUrlStatus()
            await MainActor.run { delegate?.reloadTable() }
        }
    }

    private func fetchMonitorUrls() async {
        guard let response = try? await apiManager.getMonitorUrls() else {
            delegate?.showBanner(message: "Fail to get monitor urls.", backgroundColor: .systemPink)
            return
        }
        monitorUrls = response.data.urls.compactMap { URL(string: $0) }
    }

    private func checkAllUrlStatus() async {
        linkCellConfigs = await withTaskGroup(of: (URL, HTTPURLResponse)?.self, returning: [RVCLinkCellConfig].self) { group in
            for url in monitorUrls {
                group.addTask {
                    guard let (_, response) = try? await URLSession.shared.data(from: url),
                          let httpResponse = response as? HTTPURLResponse else {
                        return nil
                    }
                    return (url, httpResponse)
                }
            }

            var responses = [RVCLinkCellConfig]()
            for await data in group {
                guard let data else { continue }
                let isSuccess = 200 <= data.1.statusCode && data.1.statusCode <= 299
                responses.append(.init(url: data.0.absoluteString, statusCode: "\(data.1.statusCode)", isSuccess: isSuccess, updateTime: Date.now))
            }
            return responses
        }
    }

    func addNewUrl(url: String) async throws -> Bool {
        return try await apiManager.createNewMonitorUrl(link: url)
    }
}
