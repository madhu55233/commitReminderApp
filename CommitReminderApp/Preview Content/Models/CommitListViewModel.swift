//
//  CommitListViewModel.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import Foundation

class CommitListViewModel: ObservableObject {
    @Published var commitList: [CommitNode] = []

    private var username: String = ""
    private var repo: String = ""

    func configure(username: String, repo: String) {
        self.username = username
        self.repo = repo
    }

    @objc func fetchCommitsSelectorCompatible() {
        fetchCommits(username: username, repo: repo)
    }

    func fetchCommits(username: String, repo: String) {
        GitUtilities().getRecentCommits(owner: username, repo: repo) { [weak self] commits in
            DispatchQueue.main.async {
                self?.commitList = commits
            }
        }
    }
}
