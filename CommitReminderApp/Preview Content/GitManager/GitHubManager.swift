//
//  GitHubManager.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import Foundation

class GitHubManager {
    static let shared = GitHubManager()
    private init() {}

    let username = "madhu55233"
    let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")

    func fetchCommitActivity(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/events") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request
            .setValue(
                "token \(String(describing: token))",
                forHTTPHeaderField: "Authorization"
            )

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let events = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                completion(false)
                return
            }

            let calendar = Calendar.current
            let today = Date()
            let committedToday = events.contains { event in
                guard let type = event["type"] as? String, type == "PushEvent",
                      let createdAt = event["created_at"] as? String,
                      let date = ISO8601DateFormatter().date(from: createdAt)
                else { return false }
                return calendar.isDate(date, inSameDayAs: today)
            }

            DispatchQueue.main.async {
                completion(committedToday)
            }
        }
        task.resume()
    }
}
