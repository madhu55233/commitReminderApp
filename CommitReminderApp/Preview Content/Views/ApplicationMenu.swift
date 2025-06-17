//
//  ApplicationMenu.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 10/06/25.
//

import Foundation
import SwiftUI
import AppKit

enum MenuContentState {
    case commits
    case pullRequests
}

class ApplicationMenu: NSObject {
    let menu = NSMenu()
    let viewModel = CommitListViewModel()
    var statusItem: NSStatusItem?
    var contentState: MenuContentState = .commits

    func attach(to statusItem: NSStatusItem) {
        self.statusItem = statusItem
    }

    func createMenu() -> NSMenu {
        menu.removeAllItems()

        let username = KeychainManager.shared.load(service: "GitHubCommitApp", account: "username")
        let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")

        if let username = username, let _ = token {
            switch contentState {
            case .commits:
                viewModel.configure(username: username, repo: "commitReminderApp")
                viewModel.fetchCommitsSelectorCompatible()

                Timer.scheduledTimer(withTimeInterval: 60.0 * 60.0, repeats: true) { _ in
                    self.viewModel.fetchCommitsSelectorCompatible()
                }

                let contentView = CommitListView(viewModel: viewModel)
                let hostingController = NSHostingController(rootView: contentView)
                hostingController.view.frame.size = CGSize(width: 250, height: 350)

                let menuItem = NSMenuItem()
                menuItem.view = hostingController.view
                menu.addItem(menuItem)
                
                let openPRItem = NSMenuItem(title: "Pull Requests", action: #selector(showPullRequests), keyEquivalent: "")
                openPRItem.target = self
                menu.addItem(openPRItem)

            case .pullRequests:
                let prView = PullRequestMenuView()
                let hostingController = NSHostingController(rootView: prView)
                hostingController.view.frame.size = CGSize(width: 350, height: 100)

                let menuItem = NSMenuItem()
                menuItem.view = hostingController.view
                menu.addItem(menuItem)

            
                let backItem = NSMenuItem(title: "Back to Commits", action: #selector(showCommits), keyEquivalent: "")
                backItem.target = self
                menu.addItem(backItem)
            }
        } else {
            let inputView = InputView {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if let button = self.statusItem?.button {
                        self.statusItem?.menu = self.createMenu()
                        button.performClick(nil)
                    }
                }
            }

            let topView = NSHostingController(rootView: inputView)
            topView.view.frame.size = CGSize(width: 225, height: 200)

            let menuItem = NSMenuItem()
            menuItem.view = topView.view
            menu.addItem(menuItem)
            menu.addItem(.separator())
        }

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

        return menu
    }

    // MARK: - View Switching Actions

    @objc func showPullRequests() {
        contentState = .pullRequests
        if let button = statusItem?.button {
            statusItem?.menu = createMenu()
            button.performClick(nil)
        }
    }

    @objc func showCommits() {
        contentState = .commits
        if let button = statusItem?.button {
            statusItem?.menu = createMenu()
            button.performClick(nil)
        }
    }
}
