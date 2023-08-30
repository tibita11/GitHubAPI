//
//  SearchHistoryManager.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/30.
//

import Foundation

class SearchHistoryManager {
    
    private let userDefaults = UserDefaults.standard

    func getSearchHistory() -> [String]? {
        return userDefaults.array(forKey: Const.searchHistoryKey) as? [String]
    }
    
    func saveSearchHistory(value: [String]) {
        userDefaults.set(value, forKey: Const.searchHistoryKey)
    }
    
    func deleteSearchHistory(row: Int) {
        guard var searchHistory = getSearchHistory() else {
            return
        }
        searchHistory.remove(at: row)
        saveSearchHistory(value: searchHistory)
    }
    
    func deleteAllSearchHistory() {
        userDefaults.removeObject(forKey: Const.searchHistoryKey)
    }
}
