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
        VStack(alignment: .leading, spacing: 8) {
            Text("Pull Requests")
                .font(.title3)
                .bold()
                .padding(.bottom, 4)

            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Fetching recent pull requests...")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.top, 10)
            } else if viewModel.pullRequests.isEmpty {
                Text("No recent pull requests")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.pullRequests.prefix(5)) { pr in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pr.title).font(.headline)
                        Link(pr.url, destination: URL(string: pr.url)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        if(pr.mergeable == "CONFLICTING"){
                            Text("Conflicting").font(.caption2).bold()
                        }                        
                    }
                }
                Divider()
            }
        }
        .padding()
        .frame(width: 350)
        .onAppear {
            let owner = GitHubManager.shared.username ?? "your-username"
            viewModel.loadPrs(owner: owner, repo: "commitReminderApp")
        }
    }
}
