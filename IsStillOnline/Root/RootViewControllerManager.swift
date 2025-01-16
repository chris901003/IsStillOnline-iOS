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
    func reloadTable(at indexPath: IndexPath?)
    func deleteTableCell(at indexPath: IndexPath)
}

class RootViewControllerManager {
    let apiManager = APIManager()

    var linkCellConfigs = [RVCLinkCellConfig]()

    var delegate: RootViewControllerManagerDelegate? {
        didSet { delegate?.reloadTable(at: nil) }
    }

    init() {
        Task {
            let urls = await fetchMonitorUrls()
            await checkAllUrlStatus(monitorUrls: urls)
            await MainActor.run { delegate?.reloadTable(at: nil) }
        }
    }

    private func fetchMonitorUrls() async -> [URL] {
        guard let response = try? await apiManager.getMonitorUrls() else {
            delegate?.showBanner(message: "Fail to get monitor urls.", backgroundColor: .systemPink)
            return []
        }
        return response.data.urls.compactMap { URL(string: $0) }
    }

    private func checkAllUrlStatus(monitorUrls: [URL]) async {
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

    private func checkSingleUrl(url: URL) async -> (RVCLinkCellConfig?, String?) {
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                return (nil, "Fail add url \(url)")
            }
            let statusCode = httpResponse.statusCode
            let isSuccess = 200 <= statusCode && statusCode <= 299
            return (.init(url: url.absoluteString, statusCode: "\(statusCode)", isSuccess: isSuccess, updateTime: Date.now), nil)
        } catch {
            return (nil, "Hostname could not be found.")
        }
    }

    func addNewUrl(url: String) async throws -> String? {
        let result = await checkSingleUrl(url: URL(string: url)!)
        if let errorMessage = result.1 { return errorMessage }
        if let conf = result.0 { linkCellConfigs.append(conf) }
        return try await apiManager.createNewMonitorUrl(link: url) ? nil : "Fail add url \(url)"
    }

    func refreshUrlAction(indexPath: IndexPath) async {
        guard let url = URL(string: linkCellConfigs[indexPath.row].url) else { return }
        let result = await checkSingleUrl(url: url)
        if let errorMessage = result.1 {
            delegate?.showBanner(message: errorMessage, backgroundColor: .systemPink)
        } else if let conf = result.0 {
            await MainActor.run {
                linkCellConfigs[indexPath.row] = conf
                delegate?.reloadTable(at: indexPath)
            }
        }
    }

    func deleteUrlAction(indexPath: IndexPath) async {
        let url = linkCellConfigs[indexPath.row].url
        do {
            guard try await apiManager.deleteMonitorUrl(link: url) else {
                delegate?.showBanner(message: "Fail to delete url", backgroundColor: .systemPink)
                return
            }
            await MainActor.run {
                linkCellConfigs.remove(at: indexPath.row)
                delegate?.deleteTableCell(at: indexPath)
            }
        } catch {
            delegate?.showBanner(message: "Fail to delete url", backgroundColor: .systemPink)
        }
    }
}
