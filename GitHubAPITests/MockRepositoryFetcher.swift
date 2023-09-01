//
//  Mock.swift
//  GitHubAPITests
//
//  Created by 鈴木楓香 on 2023/08/31.
//

@testable import GitHubAPI

final class MockRepositoryFetcher: RepositoryFetchPorotocol {
    var apiError: APIError?
    private let mockRepositoryList = RepositoryList(items: [
        Repository(id: 0, name: "Test1", owner: Owner(login: "Test1", avatarURL: ""), description: "Test1", forks: 0, starCount: 0, language: "Swift"),
        Repository(id: 1, name: "Test2", owner: Owner(login: "Test2", avatarURL: ""), description: "Test2", forks: 1, starCount: 1, language: "Swift")
    ])
    
    func fetchRepository(perPage: Int, searchword: String) async throws -> RepositoryList {
        if let apiError {
            throw apiError
        }
        return mockRepositoryList
    }
}
