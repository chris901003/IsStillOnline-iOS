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
    let addNewLinkButton = RVCAddNewLinkView()
    let newUrlInputView = RVCNewUrlInputView()
    let copyrightView = UILabel()
    let tableView = UITableView()

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

        view.bringSubviewToFront(newUrlInputView)
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            await manager.refreshUrlAction(indexPath: indexPath)
        }
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
