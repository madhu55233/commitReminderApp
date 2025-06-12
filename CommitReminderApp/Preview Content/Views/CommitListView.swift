//
//  CommitListView.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import SwiftUI

struct CommitListView: View {
    @ObservedObject var viewModel: CommitListViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Commits")
                .font(.title3)
                .bold()
                .padding(.bottom, 4)

            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Fetching recent commits...")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.top, 10)
            } else if viewModel.commitList.isEmpty {
                Text("No recent commits")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.commitList.prefix(5)) { commit in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(commit.messageHeadline)
                            .font(.headline)
                        Text(commit.author.user?.login ?? "madhumitha0523")
                            .font(.subheadline)
                        Text(formatDate(from: commit.committedDate))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Divider()
                }
            }
        }
        .padding()
        .frame(width: 250)
    }
}

func formatDate(from dateString: String) -> String {
    let inputFormatter = ISO8601DateFormatter()
    inputFormatter.formatOptions = [.withInternetDateTime]

    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current
        return outputFormatter.string(from: date)
    } else {
        return "Invalid date"
    }
}
