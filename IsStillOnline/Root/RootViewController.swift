// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RootViewController: UIViewController {
    let cellId = "LinkCellId"

    let titleView = UILabel()
    let logoutButton = RVCAddNewLinkView()
    let addNewLinkButton = RVCAddNewLinkView()
    let newUrlInputView = RVCNewUrlInputView()
    let copyrightView = UILabel()
    let tableView = UITableView()
    let monitorButton = RVCMonitorButton()
    let fullCoverView = UIView()
    let centerLoadingView = UIActivityIndicatorView()

    let manager = RootViewControllerManager()

    override func viewDidLoad() {
        setup()
        layout()
        registerCell()
    }

    private func setup() {
        manager.delegate = self

        view.backgroundColor = .white

        titleView.text = "Links"
        titleView.font = .systemFont(ofSize: 24, weight: .bold)
        titleView.textAlignment = .center

        logoutButton.titleView.text = "Logout"
        logoutButton.backgroundColor = .systemPink
        logoutButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutAction)))

        addNewLinkButton.isUserInteractionEnabled = true
        addNewLinkButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUrlAction)))

        newUrlInputView.alpha = 0
        newUrlInputView.isHidden = true
        newUrlInputView.delegate = self

        copyrightView.text = "Copyright © 2025 Zephyr Huang"
        copyrightView.textColor = .systemGray
        copyrightView.font = .systemFont(ofSize: 12, weight: .bold)
        copyrightView.textAlignment = .center

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressAction)))

        monitorButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(monitorTapAction)))

        fullCoverView.backgroundColor = .systemGray.withAlphaComponent(0.4)
        fullCoverView.alpha = 0

        centerLoadingView.style = .large
        centerLoadingView.color = .black
        centerLoadingView.alpha = 0
    }

    private func layout() {
        view.layoutMargins = .init(top: 8, left: 8, bottom: 0, right: 8)
        let layout = view.layoutMarginsGuide

        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: layout.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: layout.topAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: layout.leadingAnchor)
        ])

        view.addSubview(addNewLinkButton)
        addNewLinkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNewLinkButton.topAnchor.constraint(equalTo: layout.topAnchor),
            addNewLinkButton.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        view.addSubview(newUrlInputView)
        newUrlInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newUrlInputView.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
            newUrlInputView.centerYAnchor.constraint(equalTo: layout.centerYAnchor)
        ])

        view.addSubview(copyrightView)
        copyrightView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyrightView.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
            copyrightView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            copyrightView.trailingAnchor.constraint(equalTo: layout.trailingAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: copyrightView.topAnchor, constant: -8)
        ])

        view.addSubview(monitorButton)
        monitorButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monitorButton.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -4),
            monitorButton.bottomAnchor.constraint(equalTo: copyrightView.topAnchor, constant: -12)
        ])

        view.addSubview(fullCoverView)
        fullCoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fullCoverView.topAnchor.constraint(equalTo: view.topAnchor),
            fullCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fullCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(centerLoadingView)
        centerLoadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerLoadingView.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
            centerLoadingView.centerYAnchor.constraint(equalTo: layout.centerYAnchor)
        ])

        view.bringSubviewToFront(newUrlInputView)
        view.bringSubviewToFront(fullCoverView)
    }

    private func registerCell() {
        tableView.register(RVCLinkCell.self, forCellReuseIdentifier: cellId)
    }
}

// MARK: - Utility
extension RootViewController {
    @objc func addUrlAction() {
        newUrlInputView.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            newUrlInputView.alpha = 1
        }
    }

    @objc private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let location = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: location) {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()

            let bottomVC = RVCBottomViewController(config: manager.linkCellConfigs[indexPath.row])
            if let sheetPresentationController =  bottomVC.sheetPresentationController {
                sheetPresentationController.detents = [
                    .custom(resolver: { context in
                        context.maximumDetentValue * 0.3
                    }),
                    .medium()
                ]
            }
            present(bottomVC, animated: true)
        }
    }

    @objc private func monitorTapAction() {
        monitorButton.config(isStart: !manager.isStartMonitor)
        Task {
            let res = await manager.changeMonitorStatus(to: !manager.isStartMonitor)
            if !res {
                await MainActor.run { monitorButton.config(isStart: manager.isStartMonitor) }
            }
        }
    }

    @objc private func logoutAction() {
        centerLoadingView.startAnimating()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            fullCoverView.alpha = 1
            centerLoadingView.alpha = 1
        }
        Task {
            let result = await manager.logout()
            if result {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true)
            } else {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self else { return }
                    fullCoverView.alpha = 0
                    centerLoadingView.alpha = 0
                    showBanner(message: "Fail to logout", backgroundColor: .systemPink)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.linkCellConfigs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RVCLinkCell else {
            return UITableViewCell()
        }
        cell.configCell(config: manager.linkCellConfigs[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            Task { [weak self] in
                await self?.manager.deleteUrlAction(indexPath: indexPath)
                completionHandler(true)
            }
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - RootViewControllerManagerDelegate
extension RootViewController: RootViewControllerManagerDelegate {
    func reloadTable(at indexPath: IndexPath?) {
        if let indexPath {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.reloadData()
        }
    }

    func deleteTableCell(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .left)
    }

    func showBanner(message: String, backgroundColor: UIColor) {
        addBanner(config: .init(message: message, backgroundColor: backgroundColor))
    }

    func changeMonitorStatus(isStartMonitor: Bool) {
        monitorButton.config(isStart: isStartMonitor)
    }
}

// MARK: - RVCLinkCellDelegate
extension RootViewController: RVCLinkCellDelegate {
    func refreshUrl(at indexPath: IndexPath) {
        Task { await manager.refreshUrlAction(indexPath: indexPath) }
    }
}

// MARK: - RVCNewUrlInputViewDelegate
extension RootViewController: RVCNewUrlInputViewDelegate {
    func inputCancel() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            newUrlInputView.alpha = 0
        } completion: { [weak self] _ in
            guard let self else { return }
            newUrlInputView.isHidden = true
        }
    }

    func addNewUrl(url: String) {
        Task {
            do {
                if let result = try await manager.addNewUrl(url: url) {
                    addBanner(config: .init(message: "\(result)", backgroundColor: .systemRed))
                } else {
                    addBanner(config: .init(message: "Add url \(url)", backgroundColor: .systemGreen))
                }
            } catch {
                addBanner(config: .init(message: "Error: \(error.localizedDescription)", backgroundColor: .systemRed))
            }
            await MainActor.run {
                newUrlInputView.reset()
                tableView.reloadData()
                inputCancel()
            }
        }
    }
}
