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
    let appMenu = ApplicationMenu()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(named: NSImage.Name("CommitReminder"))
        statusItem.button?.imagePosition = .imageLeading

        appMenu.attach(to: statusItem)
        statusItem.menu = appMenu.createMenu()
    }
}
