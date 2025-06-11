//
//  ContentView.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import SwiftUI

@main
struct CommitReminderView: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
