//
//  ReminderView.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 10/06/25.
//

import SwiftUI

struct ReminderView: View {
    @State private var username: String = ""
    @State private var token: String = ""
    @State private var saved = false

    var body: some View {
       
            VStack(spacing: 12) {
                Text("GitHub Setup").bold()
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background( RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.white))
                    .padding(.horizontal)
                    .colorScheme(.light)
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
                
                TextField("Token", text: $token)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background( RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.white))
                    .padding(.horizontal)
                    .colorScheme(.light)
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
                
                Button("Save") {
                    KeychainManager.shared.save(service: "GitHubCommitApp", account: "username", value: username)
                    KeychainManager.shared.save(service: "GitHubCommitApp", account: "token", value: token)
                    saved = true
                }
                .disabled(username.isEmpty || token.isEmpty)
                
                if saved{
                    Text("Your credentials have been succesfully saved")
                }
                
            }
            .frame(width: 220, height: 200)
            .padding()
    }
}
