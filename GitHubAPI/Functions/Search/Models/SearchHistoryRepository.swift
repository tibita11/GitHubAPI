//
//  SearchHistoryRepository.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/14.
//

import Foundation

class SearchHistoryRepository {
    private var observer: NSKeyValueObservation?
    private var searchHistories: [SearchHistory]!
    var searchHistoryIDs: [SearchHistory.ID] { searchHistories.map { $0.id }}
    
    init() {
        observer = UserDefaults.standard.observe(
            \.searchHistory,
             options: [.initial, .new],
             changeHandler: { [weak self] userDefaults, changeValue in
                 guard let self else { return }
                 searchHistories = (changeValue.newValue ?? []).map { title in
                     SearchHistory(id: UUID(), title: title)
                 }
             })
    }
    
    
    // MARK: - Action
    
    func searchHistory(id: SearchHistory.ID) -> SearchHistory? {
        searchHistories.first(where: { $0.id == id })
    }
}


// MARK: - UserDefaults

extension UserDefaults {
    @objc dynamic var searchHistory: [String] {
        return array(forKey: Const.searchHistoryKey) as? [String] ?? []
    }
}
