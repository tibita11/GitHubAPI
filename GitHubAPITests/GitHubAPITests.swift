//
//  GitHubAPITests.swift
//  GitHubAPITests
//
//  Created by 鈴木楓香 on 2023/08/12.
//

import XCTest
@testable import GitHubAPI

final class GitHubAPITests: XCTestCase {

    let testName = "testDB"
    var userDefaults: UserDefaults!
    var searchHistoryManager: SearchHistoryManager!
        
    //MEMO: 各テストメソッドが実行される前
    override func setUp() {
        super.setUp()
        // MEMO: テスト用DBを作成する
        userDefaults = UserDefaults(suiteName: testName)!
        searchHistoryManager = .init(userDefaults: userDefaults)
    }
    
    // MEMO: 各テストメソッドが実行された後
    override func tearDown() {
        // MEMO: テスト用DBを削除する
        userDefaults.removePersistentDomain(forName: testName)
    }

    func test_UserDefaultsに値が保存されること() {
        let value = "Swift"
        searchHistoryManager.saveSearchHistory(value: value)
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String]
        XCTAssertNotNil(searchHistory)
        XCTAssertTrue(searchHistory!.contains(value))
    }
    
    func test_UserDefaultsに重複がある場合に保存されないこと() {
        let value = "deplication"
        searchHistoryManager.saveSearchHistory(value: value)
        searchHistoryManager.saveSearchHistory(value: value)
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String]
        XCTAssertNotNil(searchHistory)
        XCTAssertTrue(searchHistory!.count == 1)
    }
    
    func test_UserDefaultsのデータを削除できること() {
        let value1 = "value1"
        let value2 = "value2"
        searchHistoryManager.saveSearchHistory(value: value1)
        searchHistoryManager.saveSearchHistory(value: value2)
        searchHistoryManager.deleteSearchHistory(row: 0)
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String]
        XCTAssertNotNil(searchHistory)
        XCTAssertTrue(searchHistory!.first == value2)
    }
    
    func test_UserDefaultsのデータを全て削除できること() {
        let value = "Swift"
        searchHistoryManager.saveSearchHistory(value: value)
        searchHistoryManager.deleteAllSearchHistory()
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String]
        XCTAssertNil(searchHistory)
    }

}
