//
//  AppDelegate.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var appMenu: ApplicationMenu!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(named: NSImage.Name("CommitReminder"))
        statusItem.button?.imagePosition = .imageLeading

        appMenu = ApplicationMenu()
        statusItem.menu = appMenu.createMenu()

        timer = Timer.scheduledTimer(timeInterval: 1 * 60 , target: self, selector: #selector(checkGitHub), userInfo: nil, repeats: true)
    }

    @objc public func checkGitHub() {
        GitHubManager.shared.fetchCommitActivity { committed in
            if !committed {
                NotificationManager.shared.showReminder(title : "No commit today")
            }else {
                NotificationManager.shared.showReminder(title : "Good job,you have committed today")
            }
        }
    }
}
