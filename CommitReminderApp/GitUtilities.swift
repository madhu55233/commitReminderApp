//
//  GitUtilities.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import Foundation

class GitUtilities {
    static func fetchRecentCommit(repoPath: String, completion: @escaping (String?) -> Void) {
        let result = runGitCommand(["log", "-1", "--pretty=format:%h - %s (%an)"], at: repoPath)
        let trimmed = result.output.trimmingCharacters(in: .whitespacesAndNewlines)

        if result.success && !trimmed.isEmpty {
            completion(trimmed)
        } else {
            completion(nil)
        }
    }

    private static func runGitCommand(_ args: [String], at path: String) -> (success: Bool, output: String) {
        let task = Process()
        task.currentDirectoryURL = URL(fileURLWithPath: path)
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        task.arguments = ["git"] + args

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            return (task.terminationStatus == 0, output)
        } catch {
            return (false, error.localizedDescription)
        }
    }
}
