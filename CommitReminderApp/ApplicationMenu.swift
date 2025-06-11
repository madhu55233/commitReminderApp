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

    func createMenu() -> NSMenu {
        let username = KeychainManager.shared.load(service: "GitHubCommitApp", account: "username")
        let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")

        let contentView = Group {
            if username == nil || token == nil {
                ReminderView()
            } else {
                Text("You're all set!")
                    .padding()
            }
        }

        let topView = NSHostingController(rootView: contentView)
        topView.view.frame.size = CGSize(width: 100, height: 100)

        let menuItem = NSMenuItem()
        menuItem.view = topView.view
//        menu.addItem(.separator())
        let checkCommitItem = NSMenuItem(title: "Check Recent Commit", action: #selector(checkRecentCommit), keyEquivalent: "")
        checkCommitItem.target = self
        menu.addItem(checkCommitItem)
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        menu.addItem(menuItem)
        
        return menu
    }
    
    @objc func checkRecentCommit() {
        GitUtilities.fetchRecentCommit(repoPath: "https://github.com/madhu55233/commitReminderApp.git") { commit in
            NotificationManager.shared.showNotification(title: "Latest Commit", body: commit ?? "No commits found")
        }
    }
}
