//
//  ReadmeManagerTests.swift
//  GitHubAPITests
//
//  Created by 鈴木楓香 on 2023/09/01.
//

@testable import GitHubAPI
import XCTest

final class ReadmeManagerTests: XCTestCase {
    private var readmeManager: ReadmeManager!
    private var mockReadmeFetcher: MockReadmeFetcher!

    override func setUp() {
        mockReadmeFetcher = MockReadmeFetcher()
        readmeManager = .init(readmeFetchProtocol: mockReadmeFetcher)
    }

    func test_updateが返されること() {
        mockReadmeFetcher.apiError = nil
        let exp = XCTestExpectation(description: "Connect API")
        // MEMO: 非同期処理
        Task {
            let result = await readmeManager.getAPIResult(owner: "Test", repo: "Test")
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

    func test_retryが返されること() {
        mockReadmeFetcher.apiError = .unknownError
        let exp = XCTestExpectation(description: "Connect API")
        // MEMO: 非同期処理
        Task {
            let result = await readmeManager.getAPIResult(owner: "Test", repo: "Test")
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
