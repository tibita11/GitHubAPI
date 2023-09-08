//
//  SearchViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/13.
//

import Foundation
import RxCocoa
import RxSwift

enum SearchHistorySection {
    case main
}

protocol SearchViewModelOutputs {
    var application: Driver<[String]> { get }
}

protocol SearchViewModelType {
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelType {
    var outputs: SearchViewModelOutputs { self }
    private let searchHistoryManager = SearchHistoryManager()
    private var observer: NSKeyValueObservation?
    private let searchHistory = PublishRelay<[String]>()

    // MARK: - Action

    func setUp() {
        observer = UserDefaults.standard.observe(
            \.searchHistory,
            options: [.initial, .new],
            changeHandler: { [weak self] _, changeValue in
                // MEMO: 変更後の値をUIとバインド
                self?.searchHistory.accept(changeValue.newValue ?? [])
            }
        )
    }

    func saveSearchHistory(value: String) {
        searchHistoryManager.saveSearchHistory(value: value)
    }

    func deleteSearchHistory(row: Int) {
        searchHistoryManager.deleteSearchHistory(row: row)
    }

    func clearSearchHistory() {
        searchHistoryManager.deleteAllSearchHistory()
    }

    func getSearchWord(row: Int) -> String? {
        searchHistoryManager.getSearchWord(row: row)
    }
}

// MARK: - SearchViewModelOutputs

extension SearchViewModel: SearchViewModelOutputs {
    var application: Driver<[String]> {
        searchHistory.asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: - UserDefaults

extension UserDefaults {
    @objc dynamic var searchHistory: [String] {
        array(forKey: Const.searchHistoryKey) as? [String] ?? []
    }
}
