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
    func changeMonitorStatus(isStartMonitor: Bool)
    func showQuickStart()
}

class RootViewControllerManager {
    let apiManager = APIManager()

    var linkCellConfigs = [RVCLinkCellConfig]()
    var isStartMonitor = false

    var delegate: RootViewControllerManagerDelegate? {
        didSet { delegate?.reloadTable(at: nil) }
    }

    init() {
        Task {
            let urls = await fetchMonitorUrls()
            await checkAllUrlStatus(monitorUrls: urls)
            await MainActor.run { delegate?.reloadTable(at: nil) }
            isStartMonitor = (try? await apiManager.isStartMonitor()) ?? false
            await MainActor.run { delegate?.changeMonitorStatus(isStartMonitor: isStartMonitor) }
            await MainActor.run {
                let userDefaults = UserDefaults.standard
                let firstLanchKey = "isFirstLaunch"

                if userDefaults.bool(forKey: firstLanchKey) == false {
                    delegate?.showQuickStart()
                    userDefaults.set(true, forKey: firstLanchKey)
                }
            }
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
        linkCellConfigs = await withTaskGroup(of: (URL, HTTPURLResponse?).self, returning: [RVCLinkCellConfig].self) { group in
            for url in monitorUrls {
                group.addTask {
                    var request = URLRequest(url: url)
                    request.timeoutInterval = 3
                    guard let (_, response) = try? await URLSession.shared.data(for: request),
                          let httpResponse = response as? HTTPURLResponse else {
                        return (url, nil)
                    }
                    return (url, httpResponse)
                }
            }

            var responses = [RVCLinkCellConfig]()
            for await data in group {
                if let res = data.1 {
                    let isSuccess = 200 <= res.statusCode && res.statusCode <= 299
                    responses.append(.init(url: data.0.absoluteString, statusCode: "\(res.statusCode)", isSuccess: isSuccess, updateTime: Date.now))
                } else {
                    responses.append(.init(url: data.0.absoluteString, statusCode: "408", isSuccess: false, updateTime: Date.now))
                }
            }
            return responses
        }
    }

    private func checkSingleUrl(url: URL) async -> (RVCLinkCellConfig?, String?) {
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 3
            let (_, response) = try await URLSession.shared.data(for: request)
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

    func changeMonitorStatus(to status: Bool) async -> Bool {
        isStartMonitor = status
        do {
            let result = try await apiManager.changeMonitorStatus(to: status)
            guard result else {
                await MainActor.run {
                    isStartMonitor = !status
                    delegate?.showBanner(message: "Fail to \(status ? "start" : "stop") monitor", backgroundColor: .systemPink)
                }
                return false
            }
            return true
        } catch {
            await MainActor.run {
                isStartMonitor = !status
                delegate?.showBanner(message: "Fail to \(status ? "start" : "stop") monitor", backgroundColor: .systemPink)
            }
            return false
        }
    }

    func logout() async -> Bool {
        _ = try? await apiManager.updateFirebaseToken(token: "")
        KeychainManager.deleteFromKeychain(key: KEYCHAIN_TOKEN)
        KeychainManager.deleteFromKeychain(key: KEYCHAIN_USER_UID)
        return await apiManager.deleteToken()
    }

    func deleteAccount() async -> Bool {
        await apiManager.deleteAccount()
    }
}
