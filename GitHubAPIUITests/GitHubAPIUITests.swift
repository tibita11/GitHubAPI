//
//  GitHubAPIUITests.swift
//  GitHubAPIUITests
//
//  Created by 鈴木楓香 on 2023/08/12.
//

import XCTest

final class GitHubAPIUITests: XCTestCase {

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
