//
//  SearchHistoryRepository.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/14.
//

import Foundation

class SearchHistoryRepository {
    private var searchHistories: [SearchHistory] = (UserDefaults.standard.array(forKey: Const.searchHistoryKey) as? [String] ?? []).map { title in
        SearchHistory(id: UUID(), title: title)
    }
    
    var searchHistoryIDs: [SearchHistory.ID] { searchHistories.map { $0.id }}
    
    func searchHistory(id: SearchHistory.ID) -> SearchHistory? {
        searchHistories.first(where: { $0.id == id })
    }
}
