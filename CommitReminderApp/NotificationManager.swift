//
//  NotificationManager.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("Notifications authorized")
            }
        }
    }

    func showNotification(title : String, body : String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error.localizedDescription)")
            }
        }
    }
}
