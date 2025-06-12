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
            
            let checkCommitItem = NSMenuItem(
                title: "Check Recent Commit",
                action: #selector(viewModel.fetchCommitsSelectorCompatible),
                keyEquivalent: ""
            )
            checkCommitItem.target = viewModel
            menu.addItem(checkCommitItem)
        } else {
            let contentView = Group {
                if username == nil || token == nil {
                    InputView()
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
}
