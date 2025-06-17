//
//  Models.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 11/06/25.
//

import Foundation

struct RecentCommitsResponse: Codable {
    let data: RecentCommitsData
}

struct RecentCommitsData: Codable {
    let repository: Repository?
}

struct Repository: Codable {
    let defaultBranchRef: BranchRef?
}

struct BranchRef: Codable {
    let target: Target?
}

struct Target: Codable {
    let history: History
}

struct History: Codable {
    let edges: [CommitEdge]
}

struct CommitEdge: Codable {
    let node: CommitNode
}

struct CommitNode: Codable, Identifiable {
    var id: String { url }
    let messageHeadline: String
    let committedDate: String
    let url: String
    let author: CommitAuthor
}

struct CommitAuthor: Codable {
    let name: String
    let email: String
    let user : LoginUser?
}

struct LoginUser : Codable {
    let login : String
}

struct GraphQLResponse: Decodable {
    let data: PRData
}

struct PRData: Decodable {
    let repository: RepositoryName
}

struct RepositoryName: Decodable {
    let pullRequests: PullRequests
}

struct PullRequests: Decodable {
    let nodes: [PullRequest]
}

struct PullRequest: Identifiable, Decodable {
    var id: Int { number } 
    let number: Int
    let title: String
    let mergeable: String // "MERGEABLE", "CONFLICTING", or "UNKNOWN"
}

