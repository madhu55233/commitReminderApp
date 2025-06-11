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
            if viewModel.commitList.isEmpty {
                Text("No recent commits")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.commitList.prefix(5)) { commit in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(commit.messageHeadline)
                            .font(.headline)
                        Text(commit.author.name)
                            .font(.subheadline)
                        Text(commit.committedDate)
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
