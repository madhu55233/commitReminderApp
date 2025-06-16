//
//  InputView.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 10/06/25.
//

import SwiftUI

struct InputView: View {
    @State private var username: String = ""
    @State private var token: String = ""
    @State private var saved = false
    
    var onSave: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Text("GitHub Setup").bold()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .padding(.horizontal)
                .colorScheme(.light)
                .foregroundColor(.primary)
                .textSelection(.enabled)
            
            TextField("Token", text: $token)
                .textSelection(.enabled)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .padding(.horizontal)
                .colorScheme(.light)
                .foregroundColor(.primary)
           
            Button("Save") {
                KeychainManager.shared.save(service: "GitHubCommitApp", account: "username", value: username)
                KeychainManager.shared.save(service: "GitHubCommitApp", account: "token", value: token)
                saved = true
                onSave?() 
            }
            .disabled(username.isEmpty || token.isEmpty)
            
            if saved {
                Text("Your credentials have been successfully saved")
            }
        }
        .frame(width: 220, height: 200)
        .padding()
    }
}

struct PasteableSecureField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeNSView(context: Context) -> NSSecureTextField {
        let field = NSSecureTextField()
        field.placeholderString = placeholder
        field.isEditable = true
        field.delegate = context.coordinator
        return field
    }

    func updateNSView(_ nsView: NSSecureTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: PasteableSecureField

        init(_ parent: PasteableSecureField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let field = obj.object as? NSSecureTextField {
                parent.text = field.stringValue
            }
        }
    }
}
