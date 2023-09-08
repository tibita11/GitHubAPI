//
//  SearchHistoryManager.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/30.
//

import Foundation

class SearchHistoryManager {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    private func getSearchHistory() -> [String]? {
        return userDefaults.array(forKey: Const.searchHistoryKey) as? [String]
    }

    private func setSearchHistory(value: [String]) {
        userDefaults.set(value, forKey: Const.searchHistoryKey)
    }

    func saveSearchHistory(value: String) {
        if let searchHistory = getSearchHistory() {
            // MEMO: 重複がある場合、何もしない
            guard !searchHistory.contains(value) else {
                return
            }
            let newValue = searchHistory + [value]
            setSearchHistory(value: newValue)
        } else {
            // MEMO: 登録がない場合、そのまま保存
            setSearchHistory(value: [value])
        }
    }

    func deleteSearchHistory(row: Int) {
        guard var searchHistory = getSearchHistory() else {
            return
        }
        searchHistory.remove(at: row)
        setSearchHistory(value: searchHistory)
    }

    func deleteAllSearchHistory() {
        userDefaults.removeObject(forKey: Const.searchHistoryKey)
    }

    func getSearchWord(row: Int) -> String? {
        guard let searchHistory = getSearchHistory() else {
            return nil
        }
        return searchHistory[row]
    }
}
