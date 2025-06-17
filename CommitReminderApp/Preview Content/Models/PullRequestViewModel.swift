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

    func loadPrs(owner: String, repo: String) {
        GitHubManager.shared.fetchOpenPullRequests(owner: owner, repo: repo) { prs in
            self.pullRequests = prs
        }
    }
}
