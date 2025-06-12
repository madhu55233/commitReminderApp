//
//  GitHubManager.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import Alamofire
import Foundation

class GitHubManager {
    static let shared = GitHubManager()
    private init() {}

    let username = KeychainManager.shared.load(service: "GitHubCommitApp", account: "username")
    let githubToken = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")

    func fetchCommitActivity(completion: @escaping (Bool) -> Void) {
        GitUtilities().getRecentCommits(owner: username ?? "",repo: "commitReminderApp",count: 20) { commits in
            let calendar = Calendar.current
            let today = Date()
            
            let committedToday = commits.contains { commit in
                guard let committedDate = ISO8601DateFormatter().date(from: commit.committedDate) else {
                    return false
                }
                
                let login = commit.author.user?.login
                
                return login == self.username && calendar.isDate(committedDate, inSameDayAs: today)
            }
            
            
            DispatchQueue.main.async {
                completion(committedToday)
            }
        }
    }
}
