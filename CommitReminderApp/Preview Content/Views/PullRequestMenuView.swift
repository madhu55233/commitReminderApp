//
//  PullRequestMenuView.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 16/06/25.
//

import SwiftUI

struct PullRequestMenuView: View {
    @StateObject private var viewModel = PullRequestViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("🔀 Open PRs")
                .font(.headline)

            ForEach(viewModel.pullRequests) { pr in
                HStack {
                    if pr.mergeable == "MERGEABLE" {
                        Text("✅")
                    } else if pr.mergeable == "CONFLICTING" {
                        Text("⚠️")
                    } else {
                        Text("⏳")
                    }

                    Text("#\(pr.number): \(pr.title)")
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            let owner = GitHubManager.shared.username ?? "your-username"
            viewModel.loadPrs(owner: owner, repo: "commitReminderApp")
        }
    }
}
