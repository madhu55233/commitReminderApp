//
//  GitUtilities.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import Foundation
import Alamofire

class GitUtilities {
    
    let githubApiBaseUrl = "https://api.github.com"
    let githubToken = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")
    
    func getRecentCommits(owner: String, repo: String, count: Int = 5, completion: @escaping ([CommitNode]) -> Void) {
        guard !githubToken!.isEmpty else {
            completion([])
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: githubToken!),
            .accept("application/json")
        ]
        
        let query = """
        {
          repository(owner: "\(owner)", name: "\(repo)") {
            defaultBranchRef {
              target {
                ... on Commit {
                  history(first: \(count)) {
                    edges {
                      node {
                        messageHeadline
                        committedDate
                        url
                        author {
                          name
                          email
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """
        
        let parameters: [String: Any] = [
            "query": query,
            "variables": [:]
        ]
        
        AF.request(githubApiBaseUrl + "/graphql",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(RecentCommitsResponse.self, from: data)
                    let commits = result.data.repository?.defaultBranchRef?.target?.history.edges.map { $0.node } ?? []
                    
                    print("Decoded commits:")
                    for commit in commits {
                        print("\(commit.messageHeadline) by \(commit.author.name)")
                    }
                    
                    completion(commits)
                    
                } catch {
                    print("Decoding error:", error)
                    completion([])
                }
                
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
                completion([])
                
                
            }
        }
    }

}
