//
//  GitHubManager.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import Foundation

class GitHubManager {
    static let shared = GitHubManager()

    func fetchCommitActivity(completion: @escaping (Bool) -> Void) {
        guard
            let username = KeychainManager.shared.load(service: "GitHubCommitApp", account: "username"),
            let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")
        else {
            completion(false)
            return
        }

        let url = URL(string: "https://api.github.com/users/\(username)/events")!
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let events = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                completion(false)
                return
            }

            let today = Calendar.current.startOfDay(for: Date())
            let committed = events.contains { event in
                guard let type = event["type"] as? String, type == "PushEvent",
                      let createdAt = event["created_at"] as? String,
                      let date = ISO8601DateFormatter().date(from: createdAt) else { return false }
                return Calendar.current.isDate(date, inSameDayAs: today)
            }

            DispatchQueue.main.async { completion(committed) }
        }.resume()
    }
}
