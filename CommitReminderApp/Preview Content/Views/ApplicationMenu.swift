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
    
    func createMenu() -> NSMenu {
        let username = KeychainManager.shared.load(service: "GitHubCommitApp", account: "username")
        let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")
        
        if let username = username, let _ = token {
            viewModel.fetchCommits(username: username, repo: "commitReminderApp")
            
            Timer.scheduledTimer(withTimeInterval: 60.0 * 60.0, repeats: true) { _ in
                self.viewModel.fetchCommits(username: username, repo: "commitReminderApp")
            }
            
            let contentView = CommitListView(viewModel: viewModel)
            let topView = NSHostingController(rootView: contentView)
            topView.view.frame.size = CGSize(width: 250, height: 180)
            
            let menuItem = NSMenuItem()
            menuItem.view = topView.view
            self.menu.insertItem(menuItem, at: 0)
            
            let checkCommitItem = NSMenuItem(title: "Check Recent Commit", action: #selector(checkRecentCommit), keyEquivalent: "")
            checkCommitItem.target = self
            menu.addItem(checkCommitItem)
        } else {
            let contentView = Group {
                if username == nil || token == nil {
                    ReminderView()
                }
            }
            let topView = NSHostingController(rootView: contentView)
            topView.view.frame.size = CGSize(width: 225, height: 200)
            
            let menuItem = NSMenuItem()
            menuItem.view = topView.view
            
            menu.addItem(menuItem)
            menu.addItem(.separator())
        }
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        return menu
    }
    
    @objc func checkRecentCommit() {
        GitUtilities().getRecentCommits(owner: "madhu55233", repo: "commitReminderApp") { commits in
            if let latest = commits.first {
                let body = "\(latest.messageHeadline)\n\(latest.committedDate)"
                NotificationManager.shared.showNotification(title: "Latest Commit", body: body)
            } else {
                NotificationManager.shared.showNotification(title: "Latest Commit", body: "No commits found")
            }
        }
    }
}
