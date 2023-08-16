//
//  SearchResultRepository.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/16.
//

import Foundation

class SearchResultRepository {
    private var searchResult: [SearchResult] = []
    var searchResultIDs: [SearchResult.ID] { searchResult.map { $0.id }}
    
    func getSearchResult(id: SearchResult.ID) -> SearchResult? {
        searchResult.first(where: { $0.id == id })
    }
}
