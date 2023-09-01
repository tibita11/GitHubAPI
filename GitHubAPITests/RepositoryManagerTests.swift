//
//  RepositoryManagerTests.swift
//  GitHubAPITests
//
//  Created by 鈴木楓香 on 2023/09/01.
//

import XCTest
@testable import GitHubAPI

final class RepositoryManagerTests: XCTestCase {
    
    private var repositoryManager: RepositoryManager!
    private var mockRepositoryFetcher: MockRepositoryFetcher!
    
    override func setUp() {
        mockRepositoryFetcher = MockRepositoryFetcher()
        repositoryManager = .init(repositoryFetchProtocol: mockRepositoryFetcher)
    }
    
    func test_updateが返されること() {
        mockRepositoryFetcher.apiError = nil
        let exp = XCTestExpectation(description: "Connect API")
        // MEMO: 非同期処理
        Task {
            let result = await repositoryManager.getAPIResult(perPage: 1, searchword: "Test")
            // MEMO: updateが返されることを確認する
            switch result {
            case .update:
                print("updateきたよ")
                XCTAssert(true)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func test_doNothingが返されること() {
        mockRepositoryFetcher.apiError = .notModified
        let exp = XCTestExpectation(description: "Connect API")
        // MEMO: 非同期処理
        Task {
            let result = await repositoryManager.getAPIResult(perPage: 1, searchword: "Test")
            // MEMO: updateが返されることを確認する
            switch result {
            case .doNothing:
                print("doNothingきたよ")
                XCTAssert(true)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func test_retryが返されること() {
        mockRepositoryFetcher.apiError = .unknownError
        let exp = XCTestExpectation(description: "Connect API")
        // MEMO: 非同期処理
        Task {
            let result = await repositoryManager.getAPIResult(perPage: 1, searchword: "Test")
            // MEMO: updateが返されることを確認する
            switch result {
            case .retry:
                print("retryきたよ")
                XCTAssert(true)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
