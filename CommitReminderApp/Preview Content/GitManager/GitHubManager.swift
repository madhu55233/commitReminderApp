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
    private let endpoint = "https://api.github.com/graphql"

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
    
    func fetchOpenPullRequests(owner: String, repo: String, completion: @escaping ([PullRequest]) -> Void) {
        let query = """
            query {
              repository(owner: "\(owner)", name: "\(repo)") {
                pullRequests(states: OPEN, first: 10, orderBy: {field: CREATED_AT, direction: DESC}) {
                  nodes {
                    number
                    title
                    mergeable
                    url
                  }
                }
              }
            }
            """
        
        let requestBody: [String: Any] = ["query": query]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(githubToken ?? "")",
            "Content-Type": "application/json"
        ]
        
        AF.request(endpoint, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: GraphQLResponse.self) { response in
                switch response.result {
                case .success(let graphQL):
                    DispatchQueue.main.async {
                        completion(graphQL.data.repository.pullRequests.nodes)
                    }
                case .failure(let error):
                    print("Failed to fetch PRs: \(error)")
                    completion([])
                }
            }
    }
    
}
