//
//  RepositoryModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/17.
//

import Foundation

enum RepositorySection {
    case main
}

struct RepositoryList: Decodable {
    let items: [Repository]
}

struct Repository: Hashable, Decodable {
    let id: Int
    let name: String
    let owner: Owner
    let description: String?
    let forks: Int
    let starCount: Int
    let language: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case forks
        case starCount = "stargazers_count"
        case language
    }
}

struct Owner: Hashable, Decodable {
    let login: String
    let avatarURL: String

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
