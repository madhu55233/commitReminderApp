//
//  ApplicationMenu.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 10/06/25.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject {
    let menu = NSMenu()
    let viewModel = CommitListViewModel()
    var statusItem: NSStatusItem?

    func attach(to statusItem: NSStatusItem) {
        self.statusItem = statusItem
    }

    func createMenu() -> NSMenu {
        menu.removeAllItems()

        let username = KeychainManager.shared.load(service: "GitHubCommitApp", account: "username")
        let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")
        
        if let username = username, let _ = token {
            viewModel.configure(username: username, repo: "commitReminderApp")
            viewModel.fetchCommitsSelectorCompatible()

            Timer.scheduledTimer(withTimeInterval: 60.0 * 60.0, repeats: true) { _ in
                self.viewModel.fetchCommitsSelectorCompatible()
            }

            let contentView = CommitListView(viewModel: viewModel)
            let topView = NSHostingController(rootView: contentView)
            topView.view.frame.size = CGSize(width: 250, height: 350)

            let menuItem = NSMenuItem()
            menuItem.view = topView.view
            self.menu.insertItem(menuItem, at: 0)
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

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        return menu
    }
}
