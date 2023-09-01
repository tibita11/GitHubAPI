//
//  MockReadmeFetcher.swift
//  GitHubAPITests
//
//  Created by 鈴木楓香 on 2023/09/01.
//

@testable import GitHubAPI

final class MockReadmeFetcher: ReadmeFetchProtocol {
    var apiError: APIError?
    private let mockReadme = Readme(url: "testURL")
    
    func fetchReadme(owner: String, repo: String) async throws -> Readme {
        if let apiError {
            throw apiError
        }
        return mockReadme
    }
}
