//
//  CommitListViewModel.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import Foundation

class CommitListViewModel: ObservableObject {
    @Published var commitList: [CommitNode] = []
    @Published var isLoading: Bool = true
    private var username: String = ""
    private var repo: String = ""

    func fetchCommitsSelectorCompatible() {
        isLoading = true
        GitUtilities().getRecentCommits(owner: username, repo: repo) { [weak self] commits in
            DispatchQueue.main.async {
                self?.commitList = commits
                self?.isLoading = false 
            }
        }
    }
    
    func configure(username: String, repo: String) {
        self.username = username
        self.repo = repo
    }
}
