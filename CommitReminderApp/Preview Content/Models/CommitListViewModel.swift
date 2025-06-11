//
//  CommitListViewModel.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import Foundation

class CommitListViewModel: ObservableObject {
    @Published var commitList: [CommitNode] = []

    func fetchCommits(username: String, repo: String) {
        GitUtilities().getRecentCommits(owner: username, repo: repo) { [weak self] commits in
            DispatchQueue.main.async {
                self?.commitList = commits
            }
        }
    }
}
