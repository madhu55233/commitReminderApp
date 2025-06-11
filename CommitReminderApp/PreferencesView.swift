//
//  PreferencesView.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 10/06/25.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage("githubUsername") var username: String = ""
    @AppStorage("githubToken") var token: String = ""

    var body: some View {
        Form {
            TextField("GitHub Username", text: $username)
            SecureField("GitHub Token", text: $token)
        }
        .padding()
        .frame(width: 300)
        .onDisappear {
            KeychainManager.saveToken(token)
        }
    }
}
