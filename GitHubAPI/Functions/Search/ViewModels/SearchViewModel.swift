//
//  SearchViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/13.
//

import Foundation

class SearchViewModel {
    private let userDefaults = UserDefaults.standard
    private var observer: NSKeyValueObservation!
    
    init() {
        observer = userDefaults.observe(\.searchHistory, options: [.initial, .new], changeHandler: { userDefaults, changeValue in
            // UserDefaultsが変更された時の処理
            print(changeValue)
        })
    }
    
    // MARK: - Action
    
    func saveSearchHistory(value: String) {
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String] ?? []
        let updatedHistory = searchHistory + [value]
        userDefaults.set(updatedHistory, forKey: Const.searchHistoryKey)
    }
}


// MARK: - UserDefaults

extension UserDefaults {
    @objc dynamic var searchHistory: [String] {
        return array(forKey: Const.searchHistoryKey) as? [String] ?? []
    }
}
