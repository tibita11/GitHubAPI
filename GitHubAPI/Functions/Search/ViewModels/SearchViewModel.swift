//
//  SearchViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchHistorySection {
    case main
}

struct SearchHistory: Identifiable {
    var id: UUID
    var title: String
}

protocol SearchViewModelOutputs {
    var application: Driver<NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistory.ID>> { get }
}

protocol SearchViewModelType {
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelType {
    var outputs: SearchViewModelOutputs { self }
    private let userDefaults = UserDefaults.standard
    private var repository: SearchHistoryRepository = .init()
    private let snapshot = PublishRelay<NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistory.ID>>()

    
    // MARK: - Action
    
    func setUp() {
        snapshot.accept(getSnapshot())
    }
    
    func saveSearchHistory(value: String) {
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String] ?? []
        // MEMO: すでに登録済みの場合、何もしない
        guard !searchHistory.contains(value) else {
            return
        }
        let updatedHistory = searchHistory + [value]
        userDefaults.set(updatedHistory, forKey: Const.searchHistoryKey)
        snapshot.accept(getSnapshot())
    }
    
    func deleteSearchHistory(row: Int) {
        guard var searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String] else {
            assertionFailure("Error: Failed to get DB")
            return
        }
        searchHistory.remove(at: row)
        userDefaults.set(searchHistory, forKey: Const.searchHistoryKey)
        snapshot.accept(getSnapshot())
    }
    
    func clearSearchHistory() {
        userDefaults.removeObject(forKey: Const.searchHistoryKey)
        snapshot.accept(getSnapshot())
    }
    
    private func getSnapshot() -> NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistory.ID> {
        var snapshot = NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistory.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repository.searchHistoryIDs, toSection: .main)
        return snapshot
    }
    
    func getSearchHistory(id: SearchHistory.ID) -> SearchHistory? {
        return repository.searchHistory(id: id)
    }
}


// MARK: - SearchViewModelOutputs

extension SearchViewModel: SearchViewModelOutputs {
    var application: Driver<NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistory.ID>> {
        snapshot.asDriver(onErrorDriveWith: .empty())
    }
}
