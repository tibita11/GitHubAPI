//
//  SearchViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    private let userDefaults = UserDefaults.standard
    private var observer: NSKeyValueObservation?
    
    // MARK: - Action
    
    func initialSetUp() {
        observer = userDefaults.observe(
            \.searchHistory,
             options: [.initial, .new],
             changeHandler: { userDefaults, changeValue in
                 // UserDefaultsが変更した際の処理
             })
    }
    
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
