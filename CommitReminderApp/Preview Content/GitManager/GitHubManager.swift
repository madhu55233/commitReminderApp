//
//  GitHubManager.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 09/06/25.
//

import Alamofire

import Foundation

class GitHubManager {
    static let shared = GitHubManager()
    private init() {}

    let username = "madhu55233"
    let token = KeychainManager.shared.load(service: "GitHubCommitApp", account: "token")

    func fetchCommitActivity(completion: @escaping (Bool) -> Void) {
        guard let token = token else {
            completion(false)
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        let query = """
        {
          user(login: "\(username)") {
            contributionsCollection {
              contributionCalendar {
                weeks {
                  contributionDays {
                    date
                    contributionCount
                  }
                }
              }
            }
          }
        }
        """

        let parameters: [String: Any] = [
            "query": query
        ]

        AF.request("https://api.github.com/graphql", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let result = try decoder.decode(GraphQLContributionsResponse.self, from: data)

                        let today = Date()
                        let calendar = Calendar.current
                        let allDays = result.data.user.contributionsCollection.contributionCalendar.weeks.flatMap { $0.contributionDays }

                        let committedToday = allDays.contains { day in
                            if let date = ISO8601DateFormatter().date(from: day.date) {
                                return calendar.isDate(date, inSameDayAs: today) && day.contributionCount > 0
                            }
                            return false
                        }

                        DispatchQueue.main.async {
                            completion(committedToday)
                        }

                    } catch {
                        print("Decoding error:", error)
                        completion(false)
                    }
                case .failure(let error):
                    print("Network error:", error.localizedDescription)
                    completion(false)
                }
            }
    }
}
struct GraphQLContributionsResponse: Codable {
    struct Data: Codable {
        let user: User
    }
    struct User: Codable {
        let contributionsCollection: ContributionsCollection
    }
    struct ContributionsCollection: Codable {
        let contributionCalendar: ContributionCalendar
    }
    struct ContributionCalendar: Codable {
        let weeks: [Week]
    }
    struct Week: Codable {
        let contributionDays: [Day]
    }
    struct Day: Codable {
        let date: String
        let contributionCount: Int
    }

    let data: Data
}
