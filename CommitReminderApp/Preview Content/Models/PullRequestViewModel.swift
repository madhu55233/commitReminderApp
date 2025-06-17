//
//  PullRequestViewModel.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 16/06/25.
//

import Foundation
import Alamofire

class PullRequestViewModel: ObservableObject {
    @Published var pullRequests: [PullRequest] = []
    @Published var isLoading: Bool = true

    func loadPrs(owner: String, repo: String) {
        isLoading = true
        GitHubManager.shared.fetchOpenPullRequests(owner: owner, repo: repo) { prs in
            self.pullRequests = prs
            self.isLoading = false 
        }
    }
}
